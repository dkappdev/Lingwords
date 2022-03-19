//
//  Folder.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 07.03.2022.
//

import Foundation

/// Represents folders in the file structure. Each folder can contain word sets or other folders.
public class Folder: Codable {

    // MARK: Properties

    /// Unique identifier
    public var uuid: UUID
    /// Folder name.
    public var name: String
    /// Items contained in this folder.
    public var items: [ItemProtocol] { folders + wordSets }

    /// UUID of folder containing this folder. This property is `nil` for Root folder
    public var parentFolderUUID: UUID?

    private var folders: [Folder]
    private var wordSets: [WordSet]

    // MARK: Initializers

    public init(name: String, items: [ItemProtocol]) {
        self.uuid = UUID()
        self.name = name
        self.folders = items.compactMap { $0 as? Folder }
        self.wordSets = items.compactMap { $0 as? WordSet }
    }

    // MARK: Item manipulation

    /// Adds a new item to the folder.
    /// - Parameter item: item to be added
    public func addItem(_ item: ItemProtocol) {
        if let item = item as? Folder {
            folders.append(item)
        } else if let item = item as? WordSet {
            wordSets.append(item)
        }
    }

    /// Removes the item with specified uuid from the folder
    /// - Parameter uuid: uuid of the item to be removed
    public func removeItem(withUUID uuid: UUID) {
        folders.removeAll { $0.uuid == uuid }
        wordSets.removeAll { $0.uuid == uuid }
    }

    /// Flattens all folder items (including subfolders) to a single array
    /// - Returns: folder contents as a single array
    public func flatten() -> [ItemProtocol] {
        var result: [ItemProtocol] = []
        result.append(self)
        for item in items {
            if let folder = item as? Folder {
                result += folder.flatten()
            } else if let wordSet = item as? WordSet {
                result.append(wordSet)
                result += wordSet.words
            }
        }
        return result
    }
}

// MARK: - ItemProtocol

extension Folder: ItemProtocol { }
