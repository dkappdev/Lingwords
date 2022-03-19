//
//  FolderViewModel.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 18.03.2022.
//

import Foundation

/// Folder view model
public struct FolderViewModel {

    // MARK: Properties

    var uuid: UUID
    var name: String
    var items: [ItemViewModel]

    // MARK: Initializers

    public init(uuid: UUID, name: String, items: [ItemViewModel]) {
        self.uuid = uuid
        self.name = name
        self.items = items
    }
}
