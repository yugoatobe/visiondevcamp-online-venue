import SwiftUI

struct TetraWindow: Scene {
    @Environment(AppModel.self) var appModel
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
            .nameAlert()
        }
        .windowResizability(.contentSize)
    }
}
