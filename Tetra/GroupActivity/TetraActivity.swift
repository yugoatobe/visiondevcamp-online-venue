import CoreTransferable
import GroupActivities

struct TetraActivity: GroupActivity, Transferable {
    var metadata: GroupActivityMetadata = {
        var metadata = GroupActivityMetadata()
        metadata.title = "Tetra"
        metadata.type = .generic
        return metadata
    }()
}
