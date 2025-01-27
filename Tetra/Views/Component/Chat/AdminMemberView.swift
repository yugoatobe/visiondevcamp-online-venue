import SwiftUI
import PhotosUI

struct AdminMemberView: View {
    @EnvironmentObject var appState: AppState
    @State private var groupName: String = ""
    @State private var maxMembers: String = ""
    @State private var groupDescription: String = ""
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var groupImage: Image? = nil
    @Binding var isPresented: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 20) {
                    Spacer()
                        .frame(height: geometry.safeAreaInsets.top + 60)
                    
                    Group {
                        Text("Admins")
                            .font(.headline)
                            .padding(.top, 10)

                        ForEach(fetchAdminUserMetadata(), id: \.publicKey) { user in
                            HStack(alignment: .center, spacing: 10) {
                                if let pictureURL = user.picture,
                                   let url = URL(string: pictureURL) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        case .failure:
                                            Image(systemName: "person.crop.circle.fill")
                                                .resizable()
                                                .scaledToFill()
                                        @unknown default:
                                            Image(systemName: "person.crop.circle.fill")
                                                .resizable()
                                                .scaledToFill()
                                        }
                                    }
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(user.name ?? "")
                                        .font(.body)
                                        .bold()
                                    Text(user.publicKey)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    Group {
                        Text("Members")
                            .font(.headline)
                            .padding(.top, 10)
                        ScrollView{
                            ForEach(fetchMemberUserMetadata(), id: \.publicKey) { user in
                                HStack(alignment: .center, spacing: 10) {
                                    if let pictureURL = user.picture,
                                       let url = URL(string: pictureURL) {
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                            case .failure:
                                                Image(systemName: "person.crop.circle.fill")
                                                    .resizable()
                                                    .scaledToFill()
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                    } else {
                                        Image(systemName: "person.crop.circle.fill")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                    }

                                    VStack(alignment: .leading) {
                                        Text(user.name ?? "")
                                            .font(.body)
                                            .bold()
                                        Text(user.publicKey)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(.vertical, 5)
                            }
                        }
                    }
                    Button("Leave") {
                        Task {
                            leaveGroupAction()
                        }
                    }
                }
                .padding(16)
            }

            HStack {
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 15, height: 15)
                }
                .frame(width: 15, height: 15)
                .contentShape(Circle())
                .padding(.leading)
                .padding(.bottom)

                Spacer()

                Text(appState.selectedGroup?.name ?? "")
                    .font(.title)
                    .padding(.bottom, 20)
                    .padding(.leading)
                    .padding(.trailing, 8)
            }
            .frame(height: geometry.safeAreaInsets.top + 60)
            .zIndex(1)
        }
        .padding(16)
        .edgesIgnoringSafeArea(.top)
    }

    private func fetchAdminUserMetadata() -> [UserMetadata] {
        guard let groupId = appState.selectedGroup?.id else {
            return []
        }
        let adminPublicKeys = appState.allGroupAdmin
            .filter { $0.groupId == groupId }
            .map { $0.publicKey }

        let adminMetadatas = appState.allUserMetadata.filter { user in
            adminPublicKeys.contains(user.publicKey)
        }
        return adminMetadatas
    }
    
    private func fetchMemberUserMetadata() -> [UserMetadata] {
        guard let groupId = appState.selectedGroup?.id else {
            return []
        }
        let memberPublicKeys = appState.allGroupMember
            .filter { $0.groupId == groupId }
            .map { $0.publicKey }
        
        let memberMetadatas = appState.allUserMetadata.filter { user in
            memberPublicKeys.contains(user.publicKey)
        }
        return memberMetadatas
    }
    
    private func leaveGroupAction() {
        guard let selectedOwnerAccount = appState.selectedOwnerAccount else { return }
        guard let selectedGroup = appState.selectedGroup else { return }
        appState.leaveGroup(ownerAccount: selectedOwnerAccount, group: selectedGroup)
    }
}
