//
//  FolderScreenPresenter.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 08.03.2022.
//

import Foundation

/// FolderScreen Presenter
public protocol FolderScreenPresenterProtocol: AnyObject {

    var view: FolderScreenViewProtocol? { get set }

    /// Converts specified folder to view model and asks view to show it
    /// - Parameter folder: folder model
    func show(folder: Folder)
}

public final class FolderScreenPresenter {

    // MARK: Properties

    public weak var view: FolderScreenViewProtocol?
}

// MARK: - FolderScreenPresenterProtocol

extension FolderScreenPresenter: FolderScreenPresenterProtocol {

    public func show(folder: Folder) {
        var itemViewModels: [ItemViewModel] = []
        for item in folder.items {
            if let folder = item as? Folder {
                itemViewModels.append(ItemViewModel(uuid: folder.uuid, name: folder.name, type: .folder))
            } else if let wordSet = item as? WordSet {
                itemViewModels.append(ItemViewModel(uuid: wordSet.uuid, name: wordSet.name, type: .wordSet))
            }
        }

        let folderviewModel = FolderViewModel(uuid: folder.uuid,
                                              name: folder.name,
                                              items: itemViewModels)

        view?.show(folder: folderviewModel)
    }
}
