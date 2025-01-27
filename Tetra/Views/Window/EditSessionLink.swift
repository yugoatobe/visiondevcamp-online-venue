import SwiftUI
import PhotosUI

struct SessionLinkView: View {
    @EnvironmentObject private var appState: AppState
    @State private var sheetDetailForAddSessionLink: InventoryItem?
    @State private var groupName: String = ""
    @State private var groupLink: String = ""
    @State private var maxMembers: String = ""
    @State private var groupDescription: String = ""
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var groupImage: String? = nil
    @Binding var sheetDetail: InventoryItem?
    
    var body: some View {
            
        VStack(alignment: .leading, spacing: 20) {
            
            HStack {
                Button(action: {
                    sheetDetail = nil
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 15, height: 15)
                }
                .frame(width: 15, height: 15)
                .contentShape(Circle())
                .padding(.leading, 30)
                .padding(.bottom)
                
                
                Spacer()
                
                Text("Create a Session")
                    .font(.title)
                    .padding(.bottom, 20)
                    .padding(.leading)
                
                Spacer()
                
                Button(action: {
                    Task {
                        guard
                            let group = appState.selectedGroup,
                            let account = appState.selectedOwnerAccount
                        else {
                            return
                        }
                        
                        // FaceTimeリンクをrタグに設定する
                        await appState.editGroupMetadata(ownerAccount: account, group: group, name: groupName, about: groupDescription, link: groupLink)
                        
                    }
                }) {
                    Text("Create")
                }
                .padding(.bottom)
                
            }
            .padding(.top, 10)
            
                
            HStack {
                
                Spacer()

                if let pictureURL = groupImage,
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
                    .frame(width: 180, height: 180)
                    .clipShape(Circle())
                } else {
                    
                    PhotosPicker(selection: $selectedImage, matching: .images) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                .foregroundColor(.gray)
                            
                            VStack {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray)
                                
                                Text("Add Image")
                                    .foregroundColor(.gray)
                                
                            }
                            
                        }
                        .frame(width: 180, height: 180)
                    }
                }
                Spacer()
                
            }
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Session Title")
                    .font(.headline)
                TextField("ex. Anyone can join!", text: $groupName)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                Text("Session Description")
                    .font(.headline)
                TextField("ex. This is a room for VisionDevCamp", text: $groupDescription)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                Text("Session Link")
                    .font(.headline)
                TextField("ex. https://...", text: $groupLink)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 60)
            .padding(.trailing, 60)
            
        }
        .padding()
        .onAppear {
            if let groupMetadata = appState.selectedGroup {
                groupImage = groupMetadata.picture ?? ""
                groupName = groupMetadata.name ?? ""
                groupDescription = groupMetadata.about ?? ""
            }
        }
        // Relay からOKが返ってきたら、シートを閉じる
        .onReceive(appState.$shouldCloseEditSessionLinkSheet) { shouldClose in
            if shouldClose {
                sheetDetail = nil
                appState.shouldCloseEditSessionLinkSheet = false
            }
        }

        Spacer()
        
    }
}
