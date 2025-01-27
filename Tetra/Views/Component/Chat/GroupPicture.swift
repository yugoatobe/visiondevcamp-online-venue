import SwiftUI

struct GroupPicture: View {
    let pictureUrl: String?

    var body: some View {
        if let picture = pictureUrl, let url = URL(string: picture) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 30, height: 30)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                case .failure:
                    placeholderImage
                }
            }
        } else {
            placeholderImage
        }
    }

    private var placeholderImage: some View {
        Image(systemName: "rectangle.3.group.bubble")
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}
