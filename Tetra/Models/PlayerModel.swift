import Spatial
import SwiftUI

struct PlayerModel: Codable, Hashable, Sendable, Identifiable {
    let id: UUID
    var name: String
    
    var seatPose: Pose3D?
    
}
