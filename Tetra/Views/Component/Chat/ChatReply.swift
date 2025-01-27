import SwiftUI

struct ChatReply: View {
    let replyMessage: ChatMessageMetadata
    @Binding var isHighlitedMessageAnimating: Bool
    @Binding var highlightedMessageId: String?
    let scroll: ScrollViewProxy?

    var body: some View {
        LazyVStack {
            HStack(spacing: 0) {
                Image(systemName: "arrowshape.turn.up.left")
                    .imageScale(.large)
                    .frame(width: 50, height: 50)
                    .transition(.move(edge: .bottom))

                Color.accentColor
                    .frame(width: 2)
                    .padding(.vertical, 4)

                VStack(alignment: .leading) {
//                    Text(replyMessage.userMetadata?.bestPublicName ?? replyMessage.publicKey)
                    Text(replyMessage.publicKey)
                        .font(.subheadline)
                        .bold()
                    Text(replyMessage.content)
                        .lineLimit(1)
                }
                .padding(.horizontal)

                Spacer()

                Button(action: clearReply) {
                    Image(systemName: "xmark.circle")
                        .imageScale(.large)
                }
                .buttonStyle(.plain)
            }
            .padding(.trailing, 24)
        }
        .background(.background)
        .frame(height: 50)
        .padding(.vertical, -8)
        .onTapGesture(perform: highlightMessage)
    }

    private func highlightMessage() {
        withAnimation {
            isHighlitedMessageAnimating = true
            highlightedMessageId = replyMessage.id

            // Remove the highlight after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    isHighlitedMessageAnimating = false
                }
            }

            scroll?.scrollTo(replyMessage.id, anchor: .center)
        }
    }

    private func clearReply() {
        isHighlitedMessageAnimating = false
        highlightedMessageId = nil
    }
}
