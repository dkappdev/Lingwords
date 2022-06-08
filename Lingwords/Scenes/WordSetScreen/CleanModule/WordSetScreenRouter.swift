//
//  WordSetScreenRouter.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 04.06.2022.
//

import UIKit

protocol WordSetScreenRouterProtocol: AnyObject {

    var view: (WordSetScreenViewProtocol & UIViewController)? { get set }

    /// Routes user to word with specified UUID
    /// - Parameter uuid: Word UUID
    func routeToWord(withUUID uuid: UUID)
}

final class WordSetScreenRouter {

    // MARK: Properties

    weak var view: (WordSetScreenViewProtocol & UIViewController)?
}

// MARK: - WordSetScreenRouterProtocol

extension WordSetScreenRouter: WordSetScreenRouterProtocol {

    func routeToWord(withUUID uuid: UUID) {

    }
}
