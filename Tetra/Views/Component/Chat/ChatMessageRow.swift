import SwiftUI

struct ChatMessageRow: View {
    @EnvironmentObject var appState: AppState
    let message: ChatMessageMetadata
    let isHighlighted: Bool
    let highlightedMessageId: String?
    let scroll: ScrollViewProxy?

//    @Binding var replyMessage: ChatMessageMetadata?

    var body: some View {
        MessageBubble(
            owner: message.publicKey == appState.selectedOwnerAccount?.publicKey,
            chatMessage: message,
            showTranslation: .constant(false)
        )
        .transition(.move(edge: .bottom))
        .id(message.id)
//        .onTapGesture {
//            if let replyMessage = message.replyToChatMessage {
//                withAnimation {
//                    scroll?.scrollTo(replyMessage.id, anchor: .center)
//                }
//            }
//        }
        .background(isHighlighted && highlightedMessageId == message.id ? Color.accentColor.opacity(0.2) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .contextMenu {
            contextMenuItems(message: message)
        }
    }

    private func contextMenuItems(message: ChatMessageMetadata) -> some View {
        VStack {
//            Button("Reply") {
//                withAnimation {
//                    replyMessage = message
//                }
//            }
//            .disabled(appState.selectedGroup == nil || !isMemberOrAdmin())

//            if let replyMessage = message.replyToChatMessage {
//                Button("Go to Reply") {
//                    withAnimation {
//                        scroll?.scrollTo(replyMessage.id, anchor: .center)
//                    }
//                }
//            }

            Button("Copy Text") {
                UIPasteboard.general.string = message.content
            }

            Button("Copy Event Id") {
                UIPasteboard.general.string = message.id
            }

            Divider()

            Button("Report") { }
                .tint(.red)
        }
    }



    private func isMemberOrAdmin() -> Bool {
        if let selectedGroup = appState.selectedGroup {
            return selectedGroup.isMember || selectedGroup.isAdmin
        }
        return false
    }
}
