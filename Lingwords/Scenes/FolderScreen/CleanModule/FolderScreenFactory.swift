//
//  FolderScreenFactory.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 08.03.2022.
//

import UIKit

protocol FolderScreenFactoryProtocol {

    /// Creates a new FolderScreen scene
    /// - Returns: View controller responsible for showing the created scene
    func build() -> FolderScreenViewProtocol & UIViewController
}

final class FolderScreenFactory {

    // MARK: Properties

    private let folderUUID: UUID
    private let storageService: StorageServiceProtocol

    // MARK: Initializers

    /// Creates a new FolderScreen scene.
    ///
    /// Returns `nil` if no storage service was registered in DI container
    /// and an alternative instance was not passed as an argument
    /// - Parameters:
    ///   - folderUUID: UUID of the folder that the scene should display
    ///   - storageService: Storage service used by the scene
    init?(
        folderUUID: UUID,
        storageService: StorageServiceProtocol? = DIContainer.shared.resolve(type: StorageServiceProtocol.self)
    ) {
        guard let storageService = storageService else { return nil }
        self.folderUUID = folderUUID
        self.storageService = storageService
    }
}

// MARK: - FolderScreenFactoryProtocol

extension FolderScreenFactory: FolderScreenFactoryProtocol {

    func build() -> FolderScreenViewProtocol & UIViewController {
        let view: FolderScreenViewProtocol & UIViewController = FolderScreenView()
        let interactor: FolderScreenInteractorProtocol = FolderScreenInteractor(
            folderUUID: folderUUID,
            storageService: storageService
        )
        let presenter: FolderScreenPresenterProtocol = FolderScreenPresenter()
        let router: FolderScreenRouterProtocol = FolderScreenRouter()

        view.interactor = interactor
        view.router = router
        interactor.presenter = presenter
        presenter.view = view
        router.view = view

        return view
    }
}
