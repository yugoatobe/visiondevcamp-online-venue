import Foundation
import Nostr

func handleGroupMetadata(appState: AppState, event: Event) {
    
    let tags = event.tags.map({ $0 })
    let createdAt = event.createdAt
    guard let groupId = tags.first(where: { $0.id == "d" })?.otherInformation.first else { return }
    let isPublic = tags.first(where: { $0.id == "private" }) == nil
    let isOpen = tags.first(where: { $0.id == "closed" }) == nil
    let name = tags.first(where: { $0.id == "name" })?.otherInformation.first
    let about = tags.first(where: { $0.id == "about" })?.otherInformation.first
    let picture = tags.first(where: { $0.id == "picture" })?.otherInformation.first
    let link = tags.first(where: { $0.id == "r" })?.otherInformation.first
    
//    print("name: \(name ?? "")")
//    print("link: \(link ?? "なし")")
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone.current
    let formattedDate = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(createdAt.timestamp)))
    
    let metadata = ChatGroupMetadata(
        id: groupId,
        createdAt: formattedDate,
        relayUrl: appState.selectedNip29Relay?.url ?? "",
        name: name,
        picture: picture,
        about: about,
        isPublic: isPublic,
        isOpen: isOpen,
        isMember: false,
        isAdmin: false,
        link: link
    )
    
    DispatchQueue.main.async {
        appState.allChatGroup.append(metadata)
        
        // メタデータが最新のグループを上から20個抽出
        let sorted = appState.allChatGroup.sorted { a, b in
            guard
                let dateA = dateFormatter.date(from: a.createdAt),
                let dateB = dateFormatter.date(from: b.createdAt)
            else {
                return false
            }
            return dateA > dateB
        }
        appState.allChatGroup = Array(sorted.prefix(20))
    }
}
