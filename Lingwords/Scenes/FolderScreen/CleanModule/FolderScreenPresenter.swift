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
    /// - Parameter items: array of item models
    func show(folder: Folder, withItems items: [Item])
}

final class FolderScreenPresenter {

    // MARK: Properties

    weak var view: FolderScreenViewProtocol?
}

// MARK: - FolderScreenPresenterProtocol

extension FolderScreenPresenter: FolderScreenPresenterProtocol {

    func show(folder: Folder, withItems items: [Item]) {
        let itemViewModels: [FolderViewModel.Item] = items.compactMap {
            switch $0 {
            case let .folder(folder):
                return .folder(name: folder.name, uuid: folder.uuid)
            case let .wordSet(wordSet):
                return .wordSet(name: wordSet.name, uuid: wordSet.uuid)
            case .word:
                return nil
            }
        }

        let folderViewModel = FolderViewModel(uuid: folder.uuid, name: folder.name, items: itemViewModels)

        view?.show(folder: folderViewModel)
    }
}
