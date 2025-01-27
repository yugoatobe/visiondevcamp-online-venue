import SwiftUI
import Nostr
import SwiftData

struct StartView: View {
    
    @State var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            
            ZStack(alignment: .center) {
                Color.clear
                    .overlay(alignment: .top) {
                        Image("TetraPot")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
            }
            .edgesIgnoringSafeArea(.all)
            .safeAreaInset(edge: .bottom) {
                
                VStack(spacing: 8) {
                    
                    VStack(spacing: 2) {
                        Text("Tetra")
                            .font(.system(size: 56, weight: .black))
                            .foregroundColor(.white)
                            .italic()
                        
                        Text("An innovative online communication tool using Persona.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .offset(x: 0, y: -8)
                        
                    }
                    .frame(maxWidth: .infinity)
                    
                    LazyVStack {
                        NavigationLink("Get Started", value: 0)
                            .buttonStyle(.borderedProminent)
                        
                    }
                    .controlSize(.large)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .background(.black)
                
            }
            .navigationDestination(for: Int.self) { t in
                switch t {
                case 0:
                    AddChatRelayView(navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden()
                case 1:
                    AddMetadataRelayView(navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden()
                case 2:
                    AddAccountView(navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden()
                default:
                    Text("Something went wrong...")
                }
            }
        }
        
    }
}
