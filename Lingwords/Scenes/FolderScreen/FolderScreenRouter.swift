//
//  FolderScreenRouter.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 12.03.2022.
//

import UIKit

public protocol FolderScreenRouterProtocol: AnyObject {

    var view: (FolderScreenViewProtocol & UIViewController)? { get set }

    /// Routes user to folder with specified uuid
    /// - Parameter uuid: folder UUID
    func routeToSubfolder(withUUID uuid: UUID)

    /// Routes user to word set with specified uuid
    /// - Parameter uuid: word set UUID
    func routeToWordSet(withUUID uuid: UUID)
}

public final class FolderScreenRouter {

    // MARK: Properties

    public weak var view: (FolderScreenViewProtocol & UIViewController)?
}

// MARK: - FolderScreenRouterProtocol

extension FolderScreenRouter: FolderScreenRouterProtocol {

    public func routeToSubfolder(withUUID uuid: UUID) {
        let factory = FolderScreenFactory(folderUUID: uuid)
        let newView = factory.build()
        if let navigationController = view?.navigationController {
            navigationController.pushViewController(newView, animated: true)
        } else {
            view?.present(newView, animated: true, completion: nil)
        }
    }

    public func routeToWordSet(withUUID uuid: UUID) {

    }
}
