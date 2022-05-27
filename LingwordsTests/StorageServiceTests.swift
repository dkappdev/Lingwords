//
//  StorageServiceTests.swift
//  StorageServiceTests
//
//  Created by Daniil Kostitsin on 08.03.2022.
//

import XCTest
@testable import Lingwords

class StorageServiceTests: XCTestCase {

    private enum ErrorMessage: String {
        case incorrectType = "Retrieved item has incorrect type"
    }

    var storageService: StorageServiceProtocol!

    override func setUp() {
        storageService = StorageService(persistenceService: nil)
    }

    override func tearDown() {
        storageService = nil
    }

    func testShouldCreateFolders() throws {
        let englishFolder = Folder(name: "English")
        storageService.addFolder(englishFolder, toFolderWithUUID: storageService.rootFolderUUID)

        let retrievedItem = storageService.item(withUUID: englishFolder.uuid)
        XCTAssertNotNil(retrievedItem)
        guard case let .folder(retrievedEnglishFolder) = retrievedItem else {
            XCTFail(ErrorMessage.incorrectType.rawValue)
            return
        }
        XCTAssertEqual(storageService.rootFolderUUID, retrievedEnglishFolder.parentFolderUUID)
    }

    func testShouldCreateWordSets() throws {
        let englishFolder = Folder(name: "English")
        storageService.addFolder(englishFolder, toFolderWithUUID: storageService.rootFolderUUID)

        let verbsSet = WordSet(name: "Verbs", isCaseSensitive: true)
        storageService.addWordSet(verbsSet, toFolderWithUUID: englishFolder.uuid)

        let retrievedItem = storageService.item(withUUID: verbsSet.uuid)
        XCTAssertNotNil(retrievedItem)
        guard case let .wordSet(retrievedVerbsSet) = retrievedItem else {
            XCTFail(ErrorMessage.incorrectType.rawValue)
            return
        }
        XCTAssertEqual(englishFolder.uuid, retrievedVerbsSet.parentFolderUUID)
    }

    func testShouldCreateWords() throws {
        let englishFolder = Folder(name: "English")
        storageService.addFolder(englishFolder, toFolderWithUUID: storageService.rootFolderUUID)

        let verbsSet = WordSet(name: "Verbs", isCaseSensitive: true)
        storageService.addWordSet(verbsSet, toFolderWithUUID: englishFolder.uuid)

        let listenVerb = Word(term: "listen", definition: "слушать", isCompleted: false)
        storageService.addWord(listenVerb, toWordSetWithUUID: verbsSet.uuid)

        let retrievedItem = storageService.item(withUUID: listenVerb.uuid)
        XCTAssertNotNil(retrievedItem)
        guard case let .word(retrievedListVerb) = retrievedItem else {
            XCTFail(ErrorMessage.incorrectType.rawValue)
            return
        }
        XCTAssertEqual(verbsSet.uuid, retrievedListVerb.wordSetUUID)
    }

    func testShouldModifyWords() throws {
        let englishFolder = Folder(name: "English")
        storageService.addFolder(englishFolder, toFolderWithUUID: storageService.rootFolderUUID)

        let verbsSet = WordSet(name: "Verbs", isCaseSensitive: true)
        storageService.addWordSet(verbsSet, toFolderWithUUID: englishFolder.uuid)

        let incorrectVerb = Word(term: "listen", definition: "слышать", isCompleted: false)
        storageService.addWord(incorrectVerb, toWordSetWithUUID: verbsSet.uuid)

        let correctVerb = Word(term: "listen", definition: "слушать", isCompleted: false)
        storageService.updateWord(correctVerb, withUUID: incorrectVerb.uuid)

        let retrievedItem = storageService.item(withUUID: incorrectVerb.uuid)
        XCTAssertNotNil(retrievedItem)
        guard case let .word(retrievedCorrectVerb) = retrievedItem else {
            XCTFail(ErrorMessage.incorrectType.rawValue)
            return
        }
        XCTAssertEqual(incorrectVerb.uuid, retrievedCorrectVerb.uuid)
        XCTAssertEqual(verbsSet.uuid, retrievedCorrectVerb.wordSetUUID)
    }

    func testShouldRemoveWords() throws {
        let englishFolder = Folder(name: "English")
        storageService.addFolder(englishFolder, toFolderWithUUID: storageService.rootFolderUUID)

        let verbsSet = WordSet(name: "Verbs", isCaseSensitive: true)
        storageService.addWordSet(verbsSet, toFolderWithUUID: englishFolder.uuid)

        let incorrectVerb = Word(term: "listen", definition: "слышать", isCompleted: false)
        storageService.addWord(incorrectVerb, toWordSetWithUUID: verbsSet.uuid)

        XCTAssertNotNil(storageService.item(withUUID: incorrectVerb.uuid))

        storageService.removeItem(withUUID: incorrectVerb.uuid)

        XCTAssertNil(storageService.item(withUUID: incorrectVerb.uuid))
    }
}
