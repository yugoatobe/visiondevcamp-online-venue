import SwiftUI
import SwiftData

struct AddMetadataRelayView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.modelContext) private var modelContext
    
    @State private var inputText = ""
    @Binding var navigationPath: NavigationPath
    
    @Query private var relays: [Relay]
    var metadataRelays: [Relay] {
        //紛らわしいため。Nip29のために利用するリレーとNip1のために利用するリレーは異なるはず。
        relays.filter { !$0.supportsNip29 }
    }
    
    @State private var suggestedRelays: [String] = ["wss://relay.damus.io", "wss://nostr.land", "wss://yabu.me", "ws://217.142.246.199:2929"]
    var filteredSuggestedRelays: [String] {
        let relayUrls = relays.map { $0.url }
        return suggestedRelays.filter { !relayUrls.contains($0) }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            relayIcon
            relayDescription
            Divider()
            relayInput
            relayList
        }
        .padding(.top, 32)
        .padding(.bottom, 6)
        .padding(.horizontal)
        .safeAreaInset(edge: .bottom) {
            bottomBar
        }
    }
    
    private var relayIcon: some View {
        Image(systemName: "network")
            .frame(width: 50, height: 50)
            .foregroundStyle(.white)
            .imageScale(.large)
            .font(.largeTitle)
            .bold()
            .padding()
            .background(LinearGradient(colors: [.purple, .purple.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var relayDescription: some View {
        VStack(spacing: 8) {
            Text("Add Metadata Relay")
                .font(.title)
                .bold()
            Text("Adding a metadata relay allows you to retrieve and store extra info")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var relayInput: some View {
        HStack {
            TextField("wss://<metadata relay>", text: $inputText)
                .textFieldStyle(.roundedBorder)
            Button("Add") {
                Task {
                    await addRelay(relayUrl: inputText)
                }
            }
        }
    }
    
    private var relayList: some View {
        List {
            Section("Connected Metadata Relays") {
                ForEach(metadataRelays) { relay in
                    HStack {
                        Text(relay.url)
                        Spacer()
                        Button(action: {
                            Task {
                                await removeRelay(relay: relay)
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .imageScale(.large)
                                .foregroundStyle(.red)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            Section("Suggested Metadata Relays") {
                ForEach(filteredSuggestedRelays, id: \.self) { (relay: String) in
                    HStack {
                        Text(relay)
                        Spacer()
                        Button(action: {
                            Task {
                                await addRelay(relayUrl: relay)
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .imageScale(.large)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    private var bottomBar: some View {
        HStack {
            Spacer()
            Button("Back") {
                navigationPath.removeLast()
            }
            NavigationLink("Next", value: 2)
                .disabled(!nextEnabled())
        }
        .controlSize(.large)
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    
    func addRelay(relayUrl: String) async {
        guard !relays.contains(where: { $0.url == relayUrl }) else {
            inputText = ""
            return
        }
        
        if let relay = Relay.createNew(withUrl: relayUrl) {
            modelContext.insert(relay)
            do {
                try modelContext.save()
            } catch {
                print("Failed to save relay: \(error)")
            }
            
            await relay.updateRelayInfo()
            
            if !relay.supportsNip1 {
                print("This relay does not support Nip 1.")
                modelContext.delete(relay)
            } else {
                print("This relay supports Nip 1.")
                inputText = ""
            }
        }
    }
    
    func removeRelay(relay: Relay) async {
        appState.remove(relaysWithUrl: [relay.url])
        modelContext.delete(relay)
        do {
            try modelContext.save()
        } catch {
            print("Failed to remove relay: \(error)")
        }
    }
    
    func nextEnabled() -> Bool {
        !relays.isEmpty
    }
}
