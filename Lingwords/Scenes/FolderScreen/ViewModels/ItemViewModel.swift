//
//  ItemViewModel.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 08.03.2022.
//

import UIKit

/// An enum that represents item types in folders
public enum ItemType {

    /// Folder item
    case folder
    /// Word set item
    case wordSet
}

/// View model for displaying items in folders
public struct ItemViewModel {

    var type: ItemType
    var name: String
    var uuid: UUID

    var icon: UIImage? {
        switch type {
        case .folder:
            return UIImage(systemName: "folder")
        case .wordSet:
            return UIImage(systemName: "list.bullet")
        }
    }

    public init(uuid: UUID, name: String, type: ItemType) {
        self.uuid = uuid
        self.name = name
        self.type = type
    }
}
