import Combine
import GroupActivities
import RealityKit
import SwiftUI

@Observable
class GroupActivityManager {
    var session: GroupSession<TetraActivity>?
    var messenger: GroupSessionMessenger?
    var reliableMessenger: GroupSessionMessenger?
    var subscriptions = Set<AnyCancellable>()
    var tasks = Set<Task<Void, Never>>()
    var isSharePlaying = false
    

    // MARK: SharePlayセッションを開始する
    func startSession() async {
        do {
            let _ = try await TetraActivity().activate()
        } catch {
            print("Failed to activate TetraActivity: \(error)")
        }
    }

    // MARK: セッションの設定を行う
    func configureGroupSession(session: GroupSession<TetraActivity>, appState: AppState) async {
        self.session = session

        subscriptions.removeAll()
        tasks.forEach { $0.cancel() }
        tasks.removeAll()

        messenger = GroupSessionMessenger(session: session, deliveryMode: .unreliable)
        reliableMessenger = GroupSessionMessenger(session: session, deliveryMode: .reliable)
        setupStateSubscription(for: session)
        setupParticipantsSubscription(for: session)
        
        await setCoordinatorConfiguration(session: session)
        session.join()
        isSharePlaying = true
    }

    // セッションの状態を監視し、
    // セッションが無効になった場合に終了処理を行うサブスクリプションを設定する
    private func setupStateSubscription(for session: GroupSession<TetraActivity>) {
//        session.$state
//            .sink { [weak self] state in
//                if case .invalidated = state {
//                    await self?.endSession()
//                }
//            }
//            .store(in: &subscriptions)
    }

    // MARK: 参加者の変更を監視し、新しい参加者に現在の情報を送信するサブスクリプションを設定する
    private func setupParticipantsSubscription(for session: GroupSession<TetraActivity>) {
        session.$activeParticipants
            .sink { [] activeParticipants in
                let newParticipants = activeParticipants.subtracting(session.activeParticipants)
                print("newParticipants: \(newParticipants)")
            }
            .store(in: &subscriptions)
    }

    // MARK: システムコーディネータの設定を行う
    private func setCoordinatorConfiguration(session: GroupSession<TetraActivity>) async {
        if let coordinator = await session.systemCoordinator {
            var config = SystemCoordinator.Configuration()
            config.spatialTemplatePreference = .sideBySide
            config.supportsGroupImmersiveSpace = true
            coordinator.configuration = config

        }
    }

    // MARK: SharePlayセッションを終了する
    func endSession() async -> Bool {
        guard session != nil else {
            return false
        }
        isSharePlaying = false
        messenger = nil
        reliableMessenger = nil
        tasks.forEach { task in
            task.cancel()
        }
        tasks.removeAll()
        subscriptions.removeAll()
        session?.leave()
        session = nil
        
        return true
    }
}
