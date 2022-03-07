//
//  Folder.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 07.03.2022.
//

import Foundation

public class Folder: ItemProtocol {

    public var uuid = UUID()
    public let name: String
    public var items: [ItemProtocol]
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
