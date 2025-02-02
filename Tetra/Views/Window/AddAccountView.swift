import SwiftUI
import SwiftData

struct AddAccountView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.modelContext) private var modelContext
    
    @State private var inputText = ""
    @Binding var navigationPath: NavigationPath
    
    @State private var newOrImport = [0, 1]
    
    var body: some View {
        ZStack {
           
            VStack(spacing: 16) {
                
                Image(systemName: "key.horizontal")
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.white)
                    .imageScale(.large)
                    .font(.largeTitle)
                    .bold()
                    .padding()
                    .background(LinearGradient(colors: [.orange, .orange.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(spacing: 8) {
                    Text("Account Setup")
                        .font(.title)
                        .bold()
                    Text("Create a new key or import your nsec or hex key")
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.center)

                
                Divider()
                
            
                VStack(alignment: .trailing) {
                    SecureField("nsec1... or hex", text: $inputText)
                        .textFieldStyle(.roundedBorder)
                    Text("Paste in your nsec1 or hex private key to import")
                        .foregroundStyle(.tertiary)
                        .font(.caption)
                        .italic()
                }
                .padding(.vertical)
                
                Spacer()
 
                
            }
            .padding(.top, 32)
            .padding(.bottom, 6)
            .padding(.horizontal)
        }
        .safeAreaInset(edge: .bottom) {
            
            HStack {
                Spacer()
                Button("Back") {
                    self.navigationPath.removeLast()
                }
                
                if inputText.isEmpty {
                    Button("Import") {
                        
                    }
                    .buttonStyle(.bordered)
                    .disabled(true)
                    
                // TODO: アカウントの新規登録できるようにしたいけど後回し
//                    Button("New") {
//                        if let ownerAccount = OwnerAccount.createNew() {
//                            ownerAccount.selected = true
//                            modelContext.insert(ownerAccount)
//                            Task {
//                                await appState.connectAllNip29Relays()
//                                await appState.connectAllMetadataRelays()
//                            }
//                            appState.showOnboarding = false
//                        }
//                    }
//                    .buttonStyle(.borderedProminent)
                } else {
                    Button("Import") {
                        if let ownerAccount = OwnerAccount.restore(withPrivateKeyHexOrNsec: inputText) {
                            if let currentOwners = try? modelContext.fetch(FetchDescriptor<OwnerAccount>()) {
                                for owner in currentOwners {
                                    owner.selected = false
                                }
                            }
                            ownerAccount.selected = true
                            modelContext.insert(ownerAccount)
                            appState.selectedOwnerAccount = ownerAccount
                            Task {
                                await appState.subscribeGroupMetadata()
                            }
                            appState.registeredNsec = true
                        } else {
                            print("Something went wrong")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                //TODO: アカウントの新規登録できるようにしたいけど後回し
//                    Button("New") {
//                        
//                    }
//                    .buttonStyle(.bordered)
//                    .disabled(true)
                }
                    
            }
            .controlSize(.large)
            .padding(.horizontal)
            .padding(.bottom)
            
        }
    }
    
    
    func doneEnabled() -> Bool {
        //return metadataRelays.count > 0
        false
    }
}
