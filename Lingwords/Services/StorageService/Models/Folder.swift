//
//  Folder.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 07.03.2022.
//

import Foundation

/// Class for folders in the file structure. Each folder can contain word sets or other folders.
public class Folder: ItemProtocol {

    /// Unique identifier
    public var uuid = UUID()
    /// Folder name.
    public var name: String
    /// Items contained in this folder.
    public var items: [ItemProtocol]
    /// Folder that contains this folder. This value is `nil` for root folder.
    public weak var parentFolder: Folder?

    public init(name: String, items: [ItemProtocol], parentFolder: Folder?) {
        self.name = name
        self.items = items
        self.parentFolder = parentFolder
    }

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
