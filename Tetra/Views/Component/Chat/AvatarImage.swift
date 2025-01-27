import SwiftUI

struct AvatarImage: View {
    
    let avatarUrl: String
    let size: CGFloat
    
    var body: some View {
        if let url = URL(string: avatarUrl) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: size, height: size)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(size / 2)
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: size, height: size)
                        .aspectRatio(contentMode: .fill)
                        .background(Color.gray)
                        .cornerRadius(size / 2)
                case .failure(_):
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: size, height: size)
                        .foregroundColor(.secondary)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(size / 2)
                }
            }
        } else {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: size, height: size)
                .foregroundColor(.secondary)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(size / 2)
        }
    }
}

