import SwiftUI
import GroupActivities

/// A view that presents the video content details.
struct WorldDetailView: View {
    @State var inputSharePlayLink = ""
    
    let room: (
        title: String,
        memberNum: Int,
        location: String,
        image: String,
        description: String
    )
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                backgroundView(geometry: geometry)
                    .frame(height: 300)
                    .ignoresSafeArea()
                    .position(x: geometry.size.width / 2, y: 150)
                
                VStack {
                    Spacer()

                    VStack(alignment: .leading, spacing: 15) {
                        
                        Text(room.title)
                            .font(.largeTitle)
                            .bold()
                        
                        HStack {
                            
                            Text("By")
                            
                            Text("Morinosuke")
                                .underline()

                        }
                        
                        HStack {
                            
                            Text(room.description)
                                .multilineTextAlignment(.leading)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .frame(width: geometry.size.width * 0.4)
                            
                            Spacer()
                            
                            let newFaceTimeLink = "https://facetime.apple.com/join#v=1&p=ZwAt7KeXEe+n9Y4xRDecvg&k=zyPbaG1l2PV4HUrjZFLUDoL0zQBUTwnPB2svFjYJToQ"
                            
                            Button {
                                if let url = URL(string: newFaceTimeLink) {
                                    UIApplication.shared.open(url)
                                }
                            } label: {
                                HStack {
                                    
                                    Image(systemName: "shareplay")
                                    
                                    Text("Create Instances")
                                    
                                }
                            }
                            .background(Color.green)
                            .cornerRadius(.infinity)

                            
                        }
                        
                        Text("Active Instances")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack(spacing: 10) {
                                ForEach(0..<5) { _ in
                                    Image("Personas")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 240, height: 120)
                                        .clipped()
                                }
                            }
                            .padding(.horizontal, 40) // 左右に20pxのpadding
                        }
                        
                        
                    }
                    .padding(50)
                    .padding(.bottom, 0)
                    .padding(.trailing, 100)
                    .frame(height: geometry.size.height, alignment: .bottom)

                    
                }
                
            }
                
        }
    }
    
    private func backgroundView(geometry: GeometryProxy) -> some View {
        Image("VisionDevCamp")
            .resizable()
            .scaledToFill()
            .frame(width: geometry.size.width, height: 300)
            .ignoresSafeArea()
            .clipShape(Rectangle())
    }

}
