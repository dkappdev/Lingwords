//
//  FolderScreenInteractor.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 08.03.2022.
//

import Foundation

/// FolderScreen interactor
public protocol FolderScreenInteractorProtocol: AnyObject {

    var presenter: FolderScreenPresenterProtocol? { get set }

    /// Requests folder from storage service and asks presenter to show it
    func requestFolder()

    /// Removes item with specified UUID
    /// - Parameter uuid: uuid of the item to be removed
    func removeItem(withUUID uuid: UUID)
}

public final class FolderScreenInteractor {

    // MARK: Properties

    public var presenter: FolderScreenPresenterProtocol?

    private let storageService: StorageServiceProtocol?
    private let folderUUID: UUID

    // MARK: Initializers

    public init(folderUUID uuid: UUID,
                storageService: StorageServiceProtocol?) {
        self.folderUUID = uuid
        self.storageService = storageService
    }
}

// MARK: FolderScreenInteractorProtocol

extension FolderScreenInteractor: FolderScreenInteractorProtocol {

    public func requestFolder() {
        guard let folder = storageService?.item(withUUID: folderUUID) as? Folder else { return }
        presenter?.show(folder: folder)
    }

    public func removeItem(withUUID uuid: UUID) {
        guard let folder = storageService?.item(withUUID: folderUUID) as? Folder else { return }
        storageService?.removeItem(withUUID: uuid)
        presenter?.show(folder: folder)
    }
}
