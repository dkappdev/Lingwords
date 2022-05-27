//
//  FolderViewModel.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 18.03.2022.
//

import Foundation

/// Folder view model
struct FolderViewModel {

    // MARK: Properties

    var uuid: UUID
    var name: String
    var items: [FolderItemViewModel]

    // MARK: Initializers

    init(uuid: UUID, name: String, items: [FolderItemViewModel]) {
        self.uuid = uuid
        self.name = name
        self.items = items
    }
}
