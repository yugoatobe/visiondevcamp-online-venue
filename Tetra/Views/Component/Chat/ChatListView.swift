import SwiftUI

struct ChatListView: View {
    
    @EnvironmentObject var appState: AppState
    let sortedGroups: [ChatGroupMetadata]
    let latestMessage: (String) -> ChatMessageMetadata?
    
    var body: some View {
        VStack {
            HStack {
                Text("Chat")
                    .font(.largeTitle)
                    .bold()
                    .padding(.leading, 16)
                Spacer()
                Button(action: {
                    if let ownerAccount = appState.selectedOwnerAccount {
//                        appState.createGroup(ownerAccount: ownerAccount)
                    }
                }) {
                    Image(systemName: "plus.circle")
                        .font(.title)
                }
                .buttonStyle(.plain)
            }
            .padding()
            
            List(selection: $appState.selectedGroup) {
                ForEach(sortedGroups, id: \.id) { group in
                    NavigationLink(value: group) {
                        GroupListRow(group: group, lastMessage: latestMessage(group.id))
                    }
                }
            }
            .listStyle(.automatic)
        }
    }
}

