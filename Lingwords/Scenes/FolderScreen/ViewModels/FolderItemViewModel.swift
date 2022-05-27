//
//  ItemViewModel.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 08.03.2022.
//

import UIKit

/// View model for displaying items in folders
enum FolderItemViewModel {

    case wordSet(name: String, uuid: UUID)
    case folder(name: String, uuid: UUID)

    var name: String {
        switch self {
        case let .wordSet(name, _):
            return name
        case let .folder(name, _):
            return name
        }
    }

    var uuid: UUID {
        switch self {
        case let .wordSet(_, uuid):
            return uuid
        case let .folder(_, uuid):
            return uuid
        }
    }

    var icon: UIImage? {
        switch self {
        case .folder:
            return UIImage(systemName: "folder")
        case .wordSet:
            return UIImage(systemName: "list.bullet")
        }
    }
}
