import SwiftUI
import SwiftData
import Nostr

struct ChatDetailView: View {
    
    @EnvironmentObject var appState: AppState
    
    var chatMessages: [ChatMessageMetadata] {
        return Array(
            appState.allChatMessage
                .filter { $0.groupId == appState.selectedGroup?.id }
                .sorted(by: { $0.createdAt < $1.createdAt })
                .suffix(appState.chatMessageNumResults)
        )
    }
    
    @State private var scroll: ScrollViewProxy?
    @State private var messageText = ""
    @State private var highlightedMessageId: String?
    @State private var isHighlitedMessageAnimating = false
    @FocusState private var inputFocused: Bool
    
    var body: some View {
        
        ZStack {
            ScrollViewReader { reader in
                List(chatMessages) { message in
                    ChatMessageRow(
                        message: message,
                        isHighlighted: isHighlitedMessageAnimating,
                        highlightedMessageId: highlightedMessageId,
                        scroll: scroll
                    )
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .onChange(of: chatMessages, initial: true, { oldValue, newValue in
                    DispatchQueue.main.async {
                        if let last = chatMessages.last {
                            scroll?.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                })
                .onAppear {
                    scroll = reader
                    DispatchQueue.main.async {
                        if let last = chatMessages.last {
                            scroll?.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            if isMemberOrAdmin() {
                
                HStack(spacing: 8) {
                    TextField("Write a message...", text: $messageText, axis: .vertical)
                        .textFieldStyle(.plain)
                        .onSubmit(of: .text, {
                            sendMessage()
                        })
                        .padding(.leading, 12)
                        .padding(.trailing, 8)
                        .padding(.vertical, 8)
                        .background(.background)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .focused($inputFocused)

                    Button(action: {
                        sendMessage()
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                            .padding(12)
                            .background(Color(.systemBackground))
                            .clipShape(Circle())
                    }
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(
                    .background
                )
                .overlay(alignment: .top) {
                    Color.secondary.opacity(0.3)
                        .frame(height: 1)
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                ToolbarContentView()
            }
        }
    }
    
    // MARK: 自分が選択したグループのメンバーもしくは管理者であるときにtrueを返す関数
    func isMemberOrAdmin() -> Bool {
        if let selectedGroup = appState.selectedGroup {
            return selectedGroup.isMember || selectedGroup.isAdmin
        }
        return false
    }
    
    // MARK: チャットを送る時の挙動をまとめた関数
    private func sendMessage() {
        guard let selectedOwnerAccount = appState.selectedOwnerAccount else { return }
        guard let selectedGroup = appState.selectedGroup else { return }
        let text = messageText.trimmingCharacters(in: .newlines)

        Task {
            await appState.sendChatMessage(ownerAccount: selectedOwnerAccount, group: selectedGroup, withText: text)
            if let last = chatMessages.last {
                self.scroll?.scrollTo(last.id, anchor: .bottom)
            }
        }
        messageText = ""
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
