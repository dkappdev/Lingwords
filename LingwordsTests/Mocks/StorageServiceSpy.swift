//
//  StorageServiceSpy.swift
//  LingwordsTests
//
//  Created by Daniil Kostitsin on 27.05.2022.
//

import Foundation
@testable import Lingwords

final class StorageServiceSpy: StorageServiceProtocol {
    var rootFolderUUIDCalled = false
    var returnedRootFolderUUID: UUID!

    var rootFolderUUID: UUID {
        rootFolderUUIDCalled = true
        return returnedRootFolderUUID
    }

    private(set) var itemWithUUIDCalled = false
    private(set) var itemWithUUIDPassedUUID: UUID!
    var itemWithUUIDReturnedValue: Item?

    func item(withUUID uuid: UUID) -> Item? {
        itemWithUUIDCalled = true
        itemWithUUIDPassedUUID = uuid
        return itemWithUUIDReturnedValue
    }

    private(set) var itemsInItemWithUUIDCalled = false
    private(set) var itemsInItemWithUUIDPassedUUID: UUID!
    var itemsInItemWithUUIDReturnedValue: [Item]!

    func items(inItemWithUUID uuid: UUID) -> [Item] {
        itemsInItemWithUUIDCalled = true
        itemsInItemWithUUIDPassedUUID = uuid
        return itemsInItemWithUUIDReturnedValue
    }

    private(set) var removeItemWithUUIDCalled = false
    private(set) var removeItemWithUUIDPassedUUID: UUID!

    func removeItem(withUUID uuid: UUID) {
        removeItemWithUUIDCalled = true
        removeItemWithUUIDPassedUUID = uuid
    }

    private(set) var addFolderCalled = false
    private(set) var addFolderPassedFolder: Folder!
    private(set) var addFolderPassedUUID: UUID!

    func addFolder(_ folder: Folder, toFolderWithUUID uuid: UUID) {
        addFolderCalled = true
        addFolderPassedFolder = folder
        addFolderPassedUUID = uuid
    }

    private(set) var addWordSetCalled = false
    private(set) var addWordSetPassedWordSet: WordSet!
    private(set) var addWordSetPassedUUID: UUID!

    func addWordSet(_ wordSet: WordSet, toFolderWithUUID uuid: UUID) {
        addWordSetCalled = true
        addWordSetPassedWordSet = wordSet
        addWordSetPassedUUID = uuid
    }

    private(set) var addWordCalled = false
    private(set) var addWordPassedWord: Word!
    private(set) var addWordPassedUUID: UUID!

    func addWord(_ word: Word, toWordSetWithUUID uuid: UUID) {
        addWordCalled = true
        addWordPassedWord = word
        addWordPassedUUID = uuid
    }

    private(set) var updateFolderCalled = false
    private(set) var updateFolderPassedFolder: Folder!
    private(set) var updateFolderPassedUUID: UUID!

    func updateFolder(_ folder: Folder, withUUID uuid: UUID) {
        updateFolderCalled = true
        updateFolderPassedFolder = folder
        updateFolderPassedUUID = uuid
    }

    private(set) var updateWordSetCalled = false
    private(set) var updateWordSetPassedWordSet: WordSet!
    private(set) var updateWordSetPassedUUID: UUID!

    func updateWordSet(_ wordSet: WordSet, withUUID uuid: UUID) {
        updateWordSetCalled = true
        updateWordSetPassedWordSet = wordSet
        updateWordSetPassedUUID = uuid
    }

    private(set) var updateWordCalled = false
    private(set) var updateWordPassedWord: Word!
    private(set) var updateWordPassedUUID: UUID!

    func updateWord(_ word: Word, withUUID uuid: UUID) {
        updateWordCalled = true
        updateWordPassedWord = word
        updateWordPassedUUID = uuid
    }
}
