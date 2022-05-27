//
//  FolderScreenRouter.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 12.03.2022.
//

import UIKit

protocol FolderScreenRouterProtocol: AnyObject {

    var view: (FolderScreenViewProtocol & UIViewController)? { get set }

    /// Routes user to folder with specified uuid
    /// - Parameter uuid: folder UUID
    func routeToSubfolder(withUUID uuid: UUID)

    /// Routes user to word set with specified uuid
    /// - Parameter uuid: word set UUID
    func routeToWordSet(withUUID uuid: UUID)
}

final class FolderScreenRouter {

    // MARK: Properties

    weak var view: (FolderScreenViewProtocol & UIViewController)?
}

// MARK: - FolderScreenRouterProtocol

extension FolderScreenRouter: FolderScreenRouterProtocol {

    func routeToSubfolder(withUUID uuid: UUID) {
        guard let factory = FolderScreenFactory(folderUUID: uuid) else {
            print("ERROR: Couldn't create a FolderScreenFactory!")
            return
        }
        let newView = factory.build()
        if let navigationController = view?.navigationController {
            navigationController.pushViewController(newView, animated: true)
        } else {
            view?.present(newView, animated: true, completion: nil)
        }
    }

    func routeToWordSet(withUUID uuid: UUID) {

    }
}
