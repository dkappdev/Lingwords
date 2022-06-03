//
//  StorageService.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 07.03.2022.
//

import Foundation

/// Set of methods that a storage service should implement
protocol StorageServiceProtocol {

    /// UUID of the root folder that contains all items.
    var rootFolderUUID: UUID { get }

    /// Returns an item with specified UUID
    /// - Parameter uuid: unique identifier of the item
    /// - Returns: item with specified UUID.
    func item(withUUID uuid: UUID) -> Item?

    /// Returns items in container item with specified UUID
    /// - Parameter uuid: unique identifier of container item
    /// - Returns: items in container item with specified UUID
    func items(inItemWithUUID uuid: UUID) -> [Item]

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

/// Concrete storage service implementation. This class is responsible for storing and modifying data.
final class StorageService: StorageServiceProtocol {

    // MARK: Properties

    private let persistenceService: PersistenceServiceProtocol?

    var rootFolderUUID: UUID
    private var storage: Storage

    // MARK: Initializers

    /// Creates a new instance of `StorageService`.
    ///
    /// Root folder is loaded from disk using provided persistence service.
    /// When no persistence service is provided, data is not being saved.
    /// - Parameter persistenceService: Persistence service used to save and load data.
    init(
        persistenceService: PersistenceServiceProtocol? =
            DIContainer.shared.resolve(type: PersistenceServiceProtocol.self)
    ) {
        self.persistenceService = persistenceService

        guard let storage = persistenceService?.loadFromFile(type: Storage.self) else {
            let rootFolder = Folder(name: "Library")
            let rootItem = Item.folder(rootFolder)
            self.rootFolderUUID = rootFolder.uuid
            self.storage = Storage(rootFolderUUID: rootFolder.uuid, items: [rootFolder.uuid: rootItem])
            return
        }

        self.rootFolderUUID = storage.rootFolderUUID
        self.storage = storage
    }

    // MARK: Getting items

    func item(withUUID uuid: UUID) -> Item? {
        storage.items[uuid]
    }

    func items(inItemWithUUID uuid: UUID) -> [Item] {
        storage.items.values.filter { $0.parentUUID == uuid }
    }

    // MARK: Removing items

    func removeItem(withUUID uuid: UUID) {
        removeItemAndSubitems(forItemWithUUID: uuid)
        persistenceService?.saveToFile(item: storage)
    }

    private func removeItemAndSubitems(forItemWithUUID uuid: UUID) {
        storage.items[uuid] = nil
        for item in items(inItemWithUUID: uuid) {
            removeItemAndSubitems(forItemWithUUID: item.uuid)
        }
    }

    // MARK: Adding items

    func addFolder(_ folder: Folder, toFolderWithUUID uuid: UUID) {
        var folder = folder
        folder.parentFolderUUID = uuid
        storage.items[folder.uuid] = .folder(folder)

        persistenceService?.saveToFile(item: storage)
    }

    func addWordSet(_ wordSet: WordSet, toFolderWithUUID uuid: UUID) {
        var wordSet = wordSet
        wordSet.parentFolderUUID = uuid
        storage.items[wordSet.uuid] = .wordSet(wordSet)

        persistenceService?.saveToFile(item: storage)
    }

    func addWord(_ word: Word, toWordSetWithUUID uuid: UUID) {
        var word = word
        word.wordSetUUID = uuid
        storage.items[word.uuid] = .word(word)

        persistenceService?.saveToFile(item: storage)
    }

    // MARK: Updating items

    func updateFolder(_ folder: Folder, withUUID uuid: UUID) {
        guard let parentFolderUUID = storage.items[uuid]?.parentUUID else { return }

        var folder = folder
        folder.uuid = uuid
        folder.parentFolderUUID = parentFolderUUID
        storage.items[uuid] = .folder(folder)
    }

    func updateWordSet(_ wordSet: WordSet, withUUID uuid: UUID) {
        guard let parentFolderUUID = storage.items[uuid]?.parentUUID else { return }

        var wordSet = wordSet
        wordSet.uuid = uuid
        wordSet.parentFolderUUID = parentFolderUUID
        storage.items[uuid] = .wordSet(wordSet)
    }

    func updateWord(_ word: Word, withUUID uuid: UUID) {
        guard let wordSetUUID = storage.items[uuid]?.parentUUID else { return }

        var word = word
        word.uuid = uuid
        word.wordSetUUID = wordSetUUID
        storage.items[uuid] = .word(word)
    }
}
