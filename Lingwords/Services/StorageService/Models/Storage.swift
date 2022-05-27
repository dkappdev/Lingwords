import Foundation

/// Object from this class are responsible for storing user data
struct Storage: Codable {
    let rootFolderUUID: UUID
    var items: [UUID: Item]
}
