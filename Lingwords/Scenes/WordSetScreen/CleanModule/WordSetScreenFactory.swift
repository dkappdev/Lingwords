//
//  WordSetScreenFactory.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 04.06.2022.
//

import UIKit

protocol WordSetScreenFactoryProtocol: AnyObject {

    /// Creates a new WordSet scene
    /// - Returns: View controller responsible for showing the created scene
    func build() -> WordSetScreenViewProtocol & UIViewController
}

final class WordSetScreenFactory {

    // MARK: Properties

    private let wordSetUUID: UUID
    private let storageService: StorageServiceProtocol

    // MARK: Initializers

    /// Creates a new FolderScreen scene.
    ///
    /// Returns `nil` if no storage service was registered in DI container
    /// and an alternative instance was not passed as an argument
    /// - Parameters:
    ///   - wordSetUUID: UUID of the word set that the scene should display
    ///   - storageService: Storage service used by the scene
    init?(
        wordSetUUID: UUID,
        storageService: StorageServiceProtocol? = DIContainer.shared.resolve(type: StorageServiceProtocol.self)
    ) {
        guard let storageService = storageService else { return nil }
        self.wordSetUUID = wordSetUUID
        self.storageService = storageService
    }
}

extension WordSetScreenFactory: WordSetScreenFactoryProtocol {

    func build() -> UIViewController & WordSetScreenViewProtocol {
        let view: WordSetScreenViewProtocol & UIViewController = WordSetScreenView()
        let interactor: WordSetScreenInteractorProtocol = WordSetScreenInteractor(
            wordSetUUID: wordSetUUID,
            storageService: storageService
        )
        let presenter: WordSetScreenPresenterProtocol = WordSetScreenPresenter()
        let router: WordSetScreenRouterProtocol = WordSetScreenRouter()

        view.interactor = interactor
        view.router = router
        interactor.presenter = presenter
        presenter.view = view
        router.view = view

        return view
    }
}
