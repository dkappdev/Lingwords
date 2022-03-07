//
//  LingwordsTests.swift
//  LingwordsTests
//
//  Created by Daniil Kostitsin on 08.03.2022.
//

import XCTest
@testable import Lingwords

class StorageStructureTests: XCTestCase {

    var storageService: StorageServiceProtocol!

    override func setUp() {
        storageService = StorageService()
    }

    override func tearDown() {
        storageService = nil
    }

    func testShouldCreateFolders() throws {
        let rootFolder = storageService.rootFolder
        let englishFolder = Folder(name: "English", items: [], parentFolder: nil)
        storageService.addFolder(englishFolder, toFolderWithUUID: rootFolder.uuid)

        XCTAssertNotNil(storageService.item(withUUID: englishFolder.uuid))
        XCTAssertEqual(rootFolder.uuid, englishFolder.parentFolder?.uuid)
    }

    func testShouldCreateWordSets() throws {
        let rootFolder = storageService.rootFolder
        let englishFolder = Folder(name: "English", items: [], parentFolder: nil)
        storageService.addFolder(englishFolder, toFolderWithUUID: rootFolder.uuid)

        let verbsSet = WordSet(name: "Verbs", words: [], isCaseSensitive: true, parentFolder: nil)
        storageService.addWordSet(verbsSet, toFolderWithUUID: englishFolder.uuid)

        XCTAssertNotNil(storageService.item(withUUID: verbsSet.uuid))
        XCTAssertEqual(englishFolder.uuid, verbsSet.parentFolder?.uuid)
    }

    func testShouldCreateWords() throws {
        let rootFolder = storageService.rootFolder
        let englishFolder = Folder(name: "English", items: [], parentFolder: nil)
        storageService.addFolder(englishFolder, toFolderWithUUID: rootFolder.uuid)

        let verbsSet = WordSet(name: "Verbs", words: [], isCaseSensitive: true, parentFolder: nil)
        storageService.addWordSet(verbsSet, toFolderWithUUID: englishFolder.uuid)

        let listenVerb = Word(term: "listen", definition: "слушать", isCompleted: false, wordSet: nil)
        storageService.addWord(listenVerb, toWordSetWithUUID: verbsSet.uuid)

        XCTAssertNotNil(storageService.item(withUUID: listenVerb.uuid))
        XCTAssertEqual(verbsSet.uuid, listenVerb.wordSet?.uuid)
    }

    func testShouldModifyWords() throws {
        let rootFolder = storageService.rootFolder
        let englishFolder = Folder(name: "English", items: [], parentFolder: nil)
        storageService.addFolder(englishFolder, toFolderWithUUID: rootFolder.uuid)

        let verbsSet = WordSet(name: "Verbs", words: [], isCaseSensitive: true, parentFolder: nil)
        storageService.addWordSet(verbsSet, toFolderWithUUID: englishFolder.uuid)

        let incorrectVerb = Word(term: "listen", definition: "слышать", isCompleted: false, wordSet: nil)
        storageService.addWord(incorrectVerb, toWordSetWithUUID: verbsSet.uuid)

        let correctVerb = Word(term: "listen", definition: "слушать", isCompleted: false, wordSet: nil)
        storageService.updateWord(correctVerb, withUUID: incorrectVerb.uuid)

        XCTAssertNotNil(storageService.item(withUUID: correctVerb.uuid))
        XCTAssertEqual(incorrectVerb.uuid, correctVerb.uuid)
        XCTAssertEqual(verbsSet.uuid, correctVerb.wordSet?.uuid)
    }

    func testShouldRemoveWords() throws {
        let rootFolder = storageService.rootFolder
        let englishFolder = Folder(name: "English", items: [], parentFolder: nil)
        storageService.addFolder(englishFolder, toFolderWithUUID: rootFolder.uuid)

        let verbsSet = WordSet(name: "Verbs", words: [], isCaseSensitive: true, parentFolder: nil)
        storageService.addWordSet(verbsSet, toFolderWithUUID: englishFolder.uuid)

        let incorrectVerb = Word(term: "listen", definition: "слышать", isCompleted: false, wordSet: nil)
        storageService.addWord(incorrectVerb, toWordSetWithUUID: verbsSet.uuid)

        XCTAssertNotNil(storageService.item(withUUID: incorrectVerb.uuid))

        storageService.removeItem(withUUID: incorrectVerb.uuid)

        XCTAssertNil(storageService.item(withUUID: incorrectVerb.uuid))
    }
}
