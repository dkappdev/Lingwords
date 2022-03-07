//
//  StorageService.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 07.03.2022.
//

import Foundation

// TODO: Add documentation

public protocol StorageServiceProtocol {

    var rootFolder: Folder { get }

    func item(withUUID uuid: UUID) -> ItemProtocol?

    func removeItem(withUUID uuid: UUID)

    func addFolder(_ folder: Folder, toFolderWithUUID uuid: UUID)
    func addWordSet(_ wordSet: WordSet, toFolderWithUUID uuid: UUID)
    func addWord(_ word: Word, toWordSetWithUUID uuid: UUID)

    func updateFolder(_ folder: Folder, withUUID uuid: UUID)
    func updateWordSet(_ wordSet: WordSet, withUUID uuid: UUID)
    func updateWord(_ word: Word, withUUID uuid: UUID)
}

public class StorageService: StorageServiceProtocol {

    public var rootFolder: Folder

    private var flattenedItems: [ItemProtocol] {
        rootFolder.flatten()
    }

    public init() {
        self.rootFolder = Folder(name: "Root", items: [], parentFolder: nil)
    }

    public func addFolder(_ folder: Folder, toFolderWithUUID uuid: UUID) {
        guard let parentFolder = flattenedItems.first(where: { $0.uuid == uuid }) as? Folder else { return }
        folder.parentFolder = parentFolder
        parentFolder.items.append(folder)
    }

    public func addWordSet(_ wordSet: WordSet, toFolderWithUUID uuid: UUID) {
        guard let parentFolder = flattenedItems.first(where: { $0.uuid == uuid}) as? Folder else { return }
        wordSet.parentFolder = parentFolder
        parentFolder.items.append(wordSet)
    }

    public func addWord(_ word: Word, toWordSetWithUUID uuid: UUID) {
        guard let wordSet = flattenedItems.first(where: { $0.uuid == uuid }) as? WordSet else { return }
        word.wordSet = wordSet
        wordSet.words.append(word)
    }

    public func item(withUUID uuid: UUID) -> ItemProtocol? {
        flattenedItems.first(where: { $0.uuid == uuid })
    }

    public func removeItem(withUUID uuid: UUID) {
        guard let item = flattenedItems.first(where: { $0.uuid == uuid }) else { return }

        if let word = item as? Word,
           let wordSet = word.wordSet {
            wordSet.words.removeAll { $0.uuid == word.uuid }
        } else if let wordSet = item as? WordSet,
                  let parentFolder = wordSet.parentFolder {
            parentFolder.items.removeAll { $0.uuid == wordSet.uuid }
        } else if let folder = item as? Folder,
                  let parentFolder = folder.parentFolder {
            parentFolder.items.removeAll { $0.uuid == folder.uuid }
        }
    }

    public func updateFolder(_ folder: Folder, withUUID uuid: UUID) {
        guard let foundFolder = flattenedItems.first(where: { $0.uuid == uuid }) as? Folder,
              let parentUUID = foundFolder.parentFolder?.uuid else { return }

        folder.uuid = uuid
        removeItem(withUUID: uuid)
        addFolder(folder, toFolderWithUUID: parentUUID)
    }

    public func updateWordSet(_ wordSet: WordSet, withUUID uuid: UUID) {
        guard let foundWordSet = flattenedItems.first(where: { $0.uuid == uuid }) as? WordSet,
              let parentUUID = foundWordSet.parentFolder?.uuid else { return }

        wordSet.uuid = uuid
        removeItem(withUUID: uuid)
        addWordSet(wordSet, toFolderWithUUID: parentUUID)
    }

    public func updateWord(_ word: Word, withUUID uuid: UUID) {
        guard let foundWord = flattenedItems.first(where: { $0.uuid == uuid }) as? Word,
              let parentUUID = foundWord.wordSet?.uuid else { return }

        word.uuid = uuid
        removeItem(withUUID: uuid)
        addWord(word, toWordSetWithUUID: parentUUID)
    }
}
