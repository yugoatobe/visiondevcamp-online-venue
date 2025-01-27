import SwiftUI
import SwiftData
import Nostr

struct ToolbarContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var isSheetPresented = false

    var body: some View {
        ZStack {
            if appState.selectedGroup != nil {
                HStack {
                    GroupPicture(pictureUrl: appState.selectedGroup?.picture)
                    VStack(alignment: .leading) {
                        Text(appState.selectedGroup?.name ?? "---")
                            .font(.headline)
                            .bold()
                        Text(appState.selectedGroup?.relayUrl ?? "--")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .opacity(appState.selectedGroup == nil ? 0.0 : 1.0)
                    
                    if !isMemberOrAdmin() {
                        Spacer()
                        Button(action: joinGroupAction) {
                            Text("Join")
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .cornerRadius(6)
                    }
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isSheetPresented = true
        }
        .sheet(isPresented: $isSheetPresented) {
            AdminMemberView(isPresented: $isSheetPresented)
        }
    }
    
    func isMemberOrAdmin() -> Bool {
        if let selectedGroup = appState.selectedGroup {
            return selectedGroup.isMember || selectedGroup.isAdmin
        }
        return false
    }

    private func joinGroupAction() {
        guard let selectedOwnerAccount = appState.selectedOwnerAccount else { return }
        guard let selectedGroup = appState.selectedGroup else { return }
        appState.joinGroup(ownerAccount: selectedOwnerAccount, group: selectedGroup)
    }
}
