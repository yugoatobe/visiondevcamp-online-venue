import SwiftUI
import SwiftData

struct TimeLineView: View {
    @EnvironmentObject private var appState: AppState
    
    func formatTimeStamp(_ timeStamp: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = dateFormatter.date(from: timeStamp) else {
            return timeStamp
        }
        
        dateFormatter.dateFormat = "MM/dd HH:mm"
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        List(appState.ownerPostContents, id: \.id) { post in
            VStack(spacing: 0) {
                HStack(alignment: .top, spacing: 5) {
                    if let pictureUrlString = post.picture, let url = URL(string: pictureUrlString) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } placeholder: {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 50, height: 50)
                        }
                    } else {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 50, height: 50)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(post.name ?? "匿名ユーザー")
                                .font(.headline)
                            Spacer()
                            Text(formatTimeStamp(post.timeStamp))
                                .font(.subheadline)
                        }
                        Text(post.text)
                            .font(.body)
                    }
                }
                .padding(.vertical, 10)
                
            }
        }
        .listStyle(PlainListStyle())
    }
}
