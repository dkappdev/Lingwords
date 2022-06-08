//
//  WordSetScreenInteractor.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 04.06.2022.
//

import Foundation

protocol WordSetScreenInteractorProtocol: AnyObject {

    var presenter: WordSetScreenPresenterProtocol? { get set }

    /// Requests word set from storage service and asks presenter to show it
    func requestWordSet()

    /// Remove word with specified UUID
    /// - Parameter uuid: UUID of the item to be removed
    func removeWord(withUUID uuid: UUID)
}

final class WordSetScreenInteractor {

    // MARK: Properties

    var presenter: WordSetScreenPresenterProtocol?

    private let storageService: StorageServiceProtocol
    private let wordSetUUID: UUID

    // MARK: Initializers

    init(
        wordSetUUID uuid: UUID,
        storageService: StorageServiceProtocol
    ) {
        self.wordSetUUID = uuid
        self.storageService = storageService
    }
}

// MARK: WordSetScreenInteractorProtocol

extension WordSetScreenInteractor: WordSetScreenInteractorProtocol {

    func requestWordSet() {
        guard let item = storageService.item(withUUID: wordSetUUID),
              case let .wordSet(wordSet) = item else {
            return
        }
        let words: [Word] = storageService.items(inItemWithUUID: wordSetUUID)
            .compactMap {
                if case let .word(word) = $0 {
                    return word
                }
                return nil
            }
        presenter?.show(wordSet: wordSet, withWords: words)
    }

    func removeWord(withUUID uuid: UUID) {
        storageService.removeItem(withUUID: uuid)
        requestWordSet()
    }
}
