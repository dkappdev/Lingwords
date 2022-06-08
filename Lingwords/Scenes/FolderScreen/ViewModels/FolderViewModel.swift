//
//  FolderViewModel.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 18.03.2022.
//

import UIKit

/// View model used for Folder scene
struct FolderViewModel {

    // MARK: Nested types

    enum Item {

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

    // MARK: Properties

    var uuid: UUID
    var name: String
    var items: [Self.Item]

    // MARK: Initializers

    init(uuid: UUID, name: String, items: [Self.Item]) {
        self.uuid = uuid
        self.name = name
        self.items = items
    }
}
