//
//  StorageService.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 07.03.2022.
//

import Foundation

/// Set of methods that a storage service should implement
public protocol StorageServiceProtocol {

    /// Root folder that contains all items.
    var rootFolder: Folder { get }

    /// Returns an item with specified UUID
    /// - Parameter uuid: unique identifier of the item
    /// - Returns: item with specified UUID.
    func item(withUUID uuid: UUID) -> ItemProtocol?

    /// Removes item with specified UUID
    /// - Parameter uuid: unique identifier of the item that should be removed
    func removeItem(withUUID uuid: UUID)

    /// Adds a new folder to the folder with specified UUID
    /// - Parameters:
    ///   - folder: instance of new folder
    ///   - uuid: UUID of parent folder which should contain the new folder
    func addFolder(_ folder: Folder, toFolderWithUUID uuid: UUID)
    /// Adds a new word set to the folder with specified UUID
    /// - Parameters:
    ///   - folder: instance of new word set
    ///   - uuid: UUID of parent folder which should contain the new word set
    func addWordSet(_ wordSet: WordSet, toFolderWithUUID uuid: UUID)
    /// Adds a new word to the word set with specified UUID
    /// - Parameters:
    ///   - folder: instance of new word
    ///   - uuid: UUID of word set  which should contain the new word
    func addWord(_ word: Word, toWordSetWithUUID uuid: UUID)

    /// Updates folder with the specified UUID
    /// - Parameters:
    ///   - folder: new  folder instance
    ///   - uuid: UUID of the old folder, new folder instance will have the same UUID
    func updateFolder(_ folder: Folder, withUUID uuid: UUID)
    /// Updates word set with the specified UUID
    /// - Parameters:
    ///   - folder: new  word set instance
    ///   - uuid: UUID of the old word set, new word set instance will have the same UUID
    func updateWordSet(_ wordSet: WordSet, withUUID uuid: UUID)
    /// Updates word with the specified UUID
    /// - Parameters:
    ///   - folder: new  word instance
    ///   - uuid: UUID of old word, new word instance will have the same UUID
    func updateWord(_ word: Word, withUUID uuid: UUID)
}

/// Concrete instance of storage service. This class is responsible for storing and modifying data.
public class StorageService: StorageServiceProtocol {

    public var rootFolder: Folder

    /// This property stores the entire storage tree flattened onto a single array. Used for item searching.
    private var flattenedItems: [ItemProtocol] {
        rootFolder.flatten()
    }

    /// Creates a new instance of `StorageService` with empty root folder.
    public init() {
        self.rootFolder = Folder(name: "Root", items: [], parentFolder: nil)
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
