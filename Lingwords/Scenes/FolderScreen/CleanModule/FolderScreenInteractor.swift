//
//  FolderScreenInteractor.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 08.03.2022.
//

import Foundation

/// FolderScreen interactor
protocol FolderScreenInteractorProtocol: AnyObject {

    var presenter: FolderScreenPresenterProtocol? { get set }

    /// Requests folder from storage service and asks presenter to show it
    func requestFolder()

    /// Removes item with specified UUID
    /// - Parameter uuid: UUID of the item to be removed
    func removeItem(withUUID uuid: UUID)
}

final class FolderScreenInteractor {

    // MARK: Properties

    var presenter: FolderScreenPresenterProtocol?

    private let storageService: StorageServiceProtocol
    private let folderUUID: UUID

    // MARK: Initializers

    init(
        folderUUID uuid: UUID,
        storageService: StorageServiceProtocol
    ) {
        self.folderUUID = uuid
        self.storageService = storageService
    }
}

// MARK: FolderScreenInteractorProtocol

extension FolderScreenInteractor: FolderScreenInteractorProtocol {

    func requestFolder() {
        guard let item = storageService.item(withUUID: folderUUID),
              case let .folder(folder) = item else {
            return
        }
        let folderItems = storageService.items(inItemWithUUID: folderUUID)
        presenter?.show(folder: folder, withItems: folderItems)
    }

    func removeItem(withUUID uuid: UUID) {
        storageService.removeItem(withUUID: uuid)
        requestFolder()
    }
}
