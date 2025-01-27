import SwiftUI
import SwiftData

struct GroupListRow: View {
    
    let group: ChatGroupMetadata
    let lastMessage: ChatMessageMetadata?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(group.name ?? "")
                    .bold()
                Spacer()
                Text(formatDate(for: lastMessage?.createdAt))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(group.id)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(lastMessage?.content ?? "")
                .lineLimit(2)
                .foregroundStyle(.tertiary)
        }
        .frame(height: 60)
    }
    
    func formatDate(for optionalDate: Date?) -> String {
        guard let date = optionalDate else {
            return "No Date"
        }
        
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else if let daysAgo = calendar.dateComponents([.day], from: date, to: now).day, daysAgo <= 6 {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return "Last \(formatter.string(from: date))"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy MM/dd"
            return formatter.string(from: date)
        }
    }
}
