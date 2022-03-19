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
public final class StorageService: StorageServiceProtocol {

    // MARK: Properties

    public var rootFolder: Folder

    /// This property stores the entire storage tree flattened onto a single array. Used for item searching.
    private var flattenedItems: [ItemProtocol] {
        rootFolder.flatten()
    }

    private static let fileURL = FileManager
        .default
        .urls(for: .documentDirectory, in: .userDomainMask)
        .first?
        .appendingPathComponent("userData")
        .appendingPathExtension("json")

    // MARK: Initializers

    /// Creates a new instance of `StorageService` with empty root folder.
    public init() {
        self.rootFolder = Self.loadRootFolderFromFile() ?? Folder(name: "Library", items: [])
    }

    // MARK: Getting items

    public func item(withUUID uuid: UUID) -> ItemProtocol? {
        flattenedItems.first(where: { $0.uuid == uuid })
    }

    // MARK: Removing items

    public func removeItem(withUUID uuid: UUID) {
        guard let foundItem = flattenedItems.first(where: { $0.uuid == uuid }) else { return }

        if let word = foundItem as? Word,
           let wordSetUUID = word.wordSetUUID,
           let wordSet = item(withUUID: wordSetUUID) as? WordSet {
            wordSet.removeWord(withUUID: word.uuid)
        } else if let wordSet = foundItem as? WordSet,
                  let parentFolderUUID = wordSet.parentFolderUUID,
                  let parentFolder = item(withUUID: parentFolderUUID) as? Folder {
            parentFolder.removeItem(withUUID: uuid)
        } else if let folder = foundItem as? Folder,
                  let parentFolderUUID = folder.parentFolderUUID,
                  let parentFolder = item(withUUID: parentFolderUUID) as? Folder {
            parentFolder.removeItem(withUUID: uuid)
        }

        saveToFile()
    }

    // MARK: Adding items

    public func addFolder(_ folder: Folder, toFolderWithUUID uuid: UUID) {
        guard let parentFolder = flattenedItems.first(where: { $0.uuid == uuid }) as? Folder else { return }
        folder.parentFolderUUID = uuid
        parentFolder.addItem(folder)

        saveToFile()
    }

    public func addWordSet(_ wordSet: WordSet, toFolderWithUUID uuid: UUID) {
        guard let parentFolder = flattenedItems.first(where: { $0.uuid == uuid}) as? Folder else { return }
        wordSet.parentFolderUUID = uuid
        parentFolder.addItem(wordSet)

        saveToFile()
    }

    public func addWord(_ word: Word, toWordSetWithUUID uuid: UUID) {
        guard let wordSet = flattenedItems.first(where: { $0.uuid == uuid }) as? WordSet else { return }
        word.wordSetUUID = uuid
        wordSet.addWord(word)

        saveToFile()
    }

    // MARK: Updating items

    public func updateFolder(_ folder: Folder, withUUID uuid: UUID) {
        guard let foundFolder = flattenedItems.first(where: { $0.uuid == uuid }) as? Folder,
              let parentUUID = foundFolder.parentFolderUUID else { return }

        folder.uuid = uuid
        removeItem(withUUID: uuid)
        addFolder(folder, toFolderWithUUID: parentUUID)
    }

    public func updateWordSet(_ wordSet: WordSet, withUUID uuid: UUID) {
        guard let foundWordSet = flattenedItems.first(where: { $0.uuid == uuid }) as? WordSet,
              let parentUUID = foundWordSet.parentFolderUUID else { return }

        wordSet.uuid = uuid
        removeItem(withUUID: uuid)
        addWordSet(wordSet, toFolderWithUUID: parentUUID)
    }

    public func updateWord(_ word: Word, withUUID uuid: UUID) {
        guard let foundWord = flattenedItems.first(where: { $0.uuid == uuid }) as? Word,
              let parentUUID = foundWord.wordSetUUID else { return }

        word.uuid = uuid
        removeItem(withUUID: uuid)
        addWord(word, toWordSetWithUUID: parentUUID)
    }

    // MARK: Persistence

    private func saveToFile() {
        guard let fileURL = Self.fileURL else {
            print("Failed to save user data – file URL does not exist")
            return
        }

        do {
            let data = try JSONEncoder().encode(rootFolder)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            print(error)
        }
    }

    private static func loadRootFolderFromFile() -> Folder? {
        guard let fileURL = Self.fileURL else {
            print("Failed to read user data – file URL does not exist")
            return nil
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let rootFolder = try JSONDecoder().decode(Folder.self, from: data)
            return rootFolder
        } catch {
            print(error)
            return nil
        }
    }
}
