/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view that introduces the Guess Together game, and invites the person to
  create a SharePlay group session with the current FaceTime call.
*/

import GroupActivities
import SwiftUI

/// ```
/// ┌───────────────────────────────────────┐
/// │                                       │
/// │               {   *   }               │
/// │                                       │
/// │                 Tetra!                │
/// │                                       │
/// │                                       │
/// │   Welcome! To play, join a FaceTime   │
/// │                call...                │
/// │              ┌─────────┐              │
/// │              │ Play  ▶ │              │
/// │              └─────────┘              │
/// └───────────────────────────────────────┘
/// ```
struct WelcomeView: View {
//    @Environment(AppModel.self) var appModel
    
    var body: some View {
        VStack {
            WelcomeBanner().offset(y: 20)
            
            Text("Tetra!").italic().font(.extraLargeTitle)
            
            Text("""
                Welcome to Tetra! \
                This is a space designed for learning, sharing, and focused collaboration. \
                Have fun, exchange ideas, and concentrate on your projects.
                """
            )

            .multilineTextAlignment(.center)
            .padding()
            
            Divider()
            
            SharePlayButton().padding(.vertical, 20)
        }
        .padding(.horizontal)
    }
}

struct WelcomeBanner: View {
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "figure.fishing")
                .foregroundStyle(.cyan.gradient)
                .scaleEffect(x: -1)
            Image(systemName: "figure.climbing")
                .foregroundStyle(.yellow.gradient)
            Image(systemName: "figure.badminton")
                .foregroundStyle(.orange.gradient)
                .scaleEffect(x: -1)
            
            Image(systemName: "figure.run.square.stack.fill")
                .font(.system(size: 170))
                .foregroundStyle(.purple.gradient)
                .offset(y: -20)
            
            Image(systemName: "figure.archery")
                .foregroundStyle(.red.gradient)
            Image(systemName: "figure.play")
                .foregroundStyle(.green.gradient)
                .scaleEffect(x: -1)
            Image(systemName: "figure.surfing")
                .foregroundStyle(.blue.gradient)
        }
        .font(.system(size: 50))
        .frame(maxHeight: .infinity)
    }
}

struct SharePlayButton: View {
    @StateObject
    var groupStateObserver = GroupStateObserver()
    
    var body: some View {
        ZStack {
            ShareLink(
                item: TetraActivity(),
                preview: SharePreview("Tetra!")
            ).hidden()
            
            Button("Start SharePlay", systemImage: "shareplay") {
                Task.detached {
                    try await TetraActivity().activate()
                }
            }
            .disabled(!groupStateObserver.isEligibleForGroupSession)
            .tint(.green)
        }
    }
}
