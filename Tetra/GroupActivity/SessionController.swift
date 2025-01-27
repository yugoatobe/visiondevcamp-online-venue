/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
An observable controller class that manages the active SharePlay
  group session.
*/

import GroupActivities
import Observation

@Observable @MainActor
class SessionController {
    let session: GroupSession<TetraActivity>
    let messenger: GroupSessionMessenger
    let systemCoordinator: SystemCoordinator
    
    var game: GameModel {
        get {
            gameSyncStore.game
        }
        set {
            if newValue != gameSyncStore.game {
                gameSyncStore.game = newValue
                shareLocalGameState(newValue)
            }
        }
    }
    var gameSyncStore = GameSyncStore() {
        didSet {
            gameStateChanged()
        }
    }

    var players = [Participant: PlayerModel]() {
        didSet {
            if oldValue != players {
//                updateCurrentPlayer()
            }
        }
    }
    var localPlayer: PlayerModel {
        get {
            players[session.localParticipant]!
        }
        set {
            if newValue != players[session.localParticipant] {
                players[session.localParticipant] = newValue
                shareLocalPlayerState(newValue)
            }
        }
    }
    
    init?(_ session: GroupSession<TetraActivity>, appModel: AppModel) async {
        guard let systemCoordinator = await session.systemCoordinator else {
            return nil
        }
        
        self.session = session
        self.messenger = GroupSessionMessenger(session: session)
        self.systemCoordinator = systemCoordinator

        self.localPlayer = PlayerModel(
            id: session.localParticipant.id,
            name: appModel.playerName
        )
        appModel.showPlayerNameAlert = localPlayer.name.isEmpty
        
        observeRemoteParticipantUpdates()
        configureSystemCoordinator()
        
        self.session.join()
    }
    
    func updateSpatialTemplatePreference() {
        switch game.stage {
        case .inGame(.connectMode):
            systemCoordinator.configuration.spatialTemplatePreference = .conversational
        case .inGame(.breakoutMode):
            systemCoordinator.configuration.spatialTemplatePreference = .surround
        case .inGame(.broadcastMode):
            systemCoordinator.configuration.spatialTemplatePreference = .sideBySide
        }
    }
    
    func configureSystemCoordinator() {
        systemCoordinator.configuration.supportsGroupImmersiveSpace = true
        
        Task {
            for await localParticipantState in systemCoordinator.localParticipantStates {
                localPlayer.seatPose = localParticipantState.seat?.pose
            }
        }
    }
    
    
    func startGame() {
        game.stage = .inGame(.connectMode)
    }

    
//    func endGame() {
//        game.stage = .none
//    }
    
    func gameStateChanged() {
        updateSpatialTemplatePreference()
    }
}
