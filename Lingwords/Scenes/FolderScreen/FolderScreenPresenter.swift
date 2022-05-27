//
//  FolderScreenPresenter.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 08.03.2022.
//

import Foundation

/// FolderScreen Presenter
protocol FolderScreenPresenterProtocol: AnyObject {

    var view: FolderScreenViewProtocol? { get set }

    /// Converts specified folder to view model and asks view to show it
    /// - Parameter folder: folder model
    func show(folder: Folder, withItems items: [Item])
}

final class FolderScreenPresenter {

    // MARK: Properties

    weak var view: FolderScreenViewProtocol?
}

// MARK: - FolderScreenPresenterProtocol

extension FolderScreenPresenter: FolderScreenPresenterProtocol {

    func show(folder: Folder, withItems items: [Item]) {
        var itemViewModels: [FolderItemViewModel] = []
        for item in items {
            switch item {
            case .word:
                continue
            case let .wordSet(wordSet):
                itemViewModels.append(.wordSet(name: wordSet.name, uuid: wordSet.uuid))
            case let .folder(folder):
                itemViewModels.append(.folder(name: folder.name, uuid: folder.uuid))
            }
        }

        let folderViewModel = FolderViewModel(uuid: folder.uuid,
                                              name: folder.name,
                                              items: itemViewModels)

        view?.show(folder: folderViewModel)
    }
}
