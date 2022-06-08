//
//  Folder.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 07.03.2022.
//

import Foundation

/// Represents folders in the file structure. Each folder can contain word sets or other folders.
struct Folder: Codable {

    // MARK: Properties

    /// Unique identifier
    var uuid: UUID
    /// Folder name.
    var name: String

    /// UUID of folder containing this folder. This property is `nil` for Root folder
    var parentFolderUUID: UUID?

    // MARK: Initializers

    init(name: String) {
        self.uuid = UUID()
        self.name = name
    }
}
