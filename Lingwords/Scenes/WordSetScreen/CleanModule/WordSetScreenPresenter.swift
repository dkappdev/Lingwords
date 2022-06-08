//
//  WordSetScreenPresenter.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 04.06.2022.
//

import Foundation

protocol WordSetScreenPresenterProtocol: AnyObject {

    var view: WordSetScreenViewProtocol? { get set }

    /// Converts specified word set to view model and asks view to show it
    /// - Parameters:
    ///   - wordSet: word set storage model
    ///   - words: array of words contained in the word set
    func show(wordSet: WordSet, withWords words: [Word])
}

final class WordSetScreenPresenter {

    // MARK: Properties

    weak var view: WordSetScreenViewProtocol?
}

// MARK: - WordSetScreenPresenterProtocol

extension WordSetScreenPresenter: WordSetScreenPresenterProtocol {

    func show(wordSet: WordSet, withWords words: [Word]) {
        let wordViewModels: [WordSetViewModel.Word] = words.compactMap {
            WordSetViewModel.Word(uuid: $0.uuid, term: $0.term, definition: $0.definition, isCompleted: $0.isCompleted)
        }
        let wordSetViewModel = WordSetViewModel(uuid: wordSet.uuid, name: wordSet.name, words: wordViewModels)

        view?.show(wordSet: wordSetViewModel)
    }
}
