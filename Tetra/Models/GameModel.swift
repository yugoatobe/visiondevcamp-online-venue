/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A model that represents the current state of the game
  in the SharePlay group session.
*/

import Foundation
import GroupActivities

struct GameModel: Codable, Hashable, Sendable {
    var stage: ActivityStage = .inGame(.connectMode)
    
    var currentRoundEndTime: Date?
    var activeStage: GameStage = .connectMode
}

extension GameModel {
    enum GameStage: Codable, Hashable, Sendable, CaseIterable {
        case connectMode
        case broadcastMode
        case breakoutMode
    }
    
    enum ActivityStage: Codable, Hashable, Sendable {
        case inGame(GameStage)
        
        var isInGame: Bool {
            if case .inGame = self {
                true
            } else {
                false
            }
        }
    }
}
