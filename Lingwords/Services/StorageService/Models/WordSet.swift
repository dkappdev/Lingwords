//
//  WordSet.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 07.03.2022.
//

import Foundation

/// Instances of this class represent word sets (for example: "Irregular verbs pt.1").
public class WordSet: Codable {

    // MARK: Stored properties

    /// Unique identifier
    public var uuid: UUID
    /// Name of the word set.
    public var name: String
    /// Words contained in this word set.
    private(set) var words: [Word]
    /// Indicates whether or not case-sensitive comparison should be used for user's answers.
    public var isCaseSensitive: Bool

    /// UUID of folder containing this word set
    public var parentFolderUUID: UUID?

    // MARK: Computed properties

    /// Indicates what portion of the words have been completed. Values lie in range 0 through 1,
    public var progress: Double {
        Double(completedWords.count) / Double(words.count)
    }

    /// Completed words in this word set
    public var completedWords: [Word] {
        words.filter { $0.isCompleted }
    }

    /// Non-completed words in this word set
    public var incompleteWords: [Word] {
        words.filter { !$0.isCompleted }
    }

    // MARK: Initializers

    /// Creates an instance of `WordSet` class with given parameters.
    /// - Parameters:
    ///   - name: Name of the word set.
    ///   - words: Words in this set.
    ///   - isCaseSensitive: `true` if case-sensitive comparison should be used for words in this set,
    ///   `false` otherwise.
    public init(name: String, words: [Word], isCaseSensitive: Bool) {
        self.uuid = UUID()
        self.name = name
        self.words = words
        self.isCaseSensitive = isCaseSensitive
    }

    // MARK: Item manipulation

    /// Adds a new word to the word set
    /// - Parameter word: the word to be added
    public func addWord(_ word: Word) {
        words.append(word)
    }

    /// Removes the word with specified uuid from the word set
    /// - Parameter uuid: uuid of the word to be removed
    public func removeWord(withUUID uuid: UUID) {
        words.removeAll { $0.uuid == uuid }
    }
}

// MARK: - ItemProtocol

extension WordSet: ItemProtocol { }
