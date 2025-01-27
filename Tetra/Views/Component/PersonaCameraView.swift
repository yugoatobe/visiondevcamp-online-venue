import SwiftUI

struct PersonaCameraView: View {
    @State private var personaCamera: PersonaCamera?
    @State private var image: UIImage?

    var body: some View {
        ZStack {
            if let image = self.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 400, height: 400)
                    .clipped()
            } else {
                ProgressView("Loading camera...")
            }
        }
        .onAppear {
            personaCamera = PersonaCamera(callback: { image in
                self.image = image
            })
            Task {
                await personaCamera?.setupCamera()
            }
        }
    }
}
