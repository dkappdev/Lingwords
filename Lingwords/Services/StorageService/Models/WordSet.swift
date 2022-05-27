//
//  WordSet.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 07.03.2022.
//

import Foundation

/// Instances of this class represent word sets (for example: "Irregular verbs pt.1").
struct WordSet: Codable {

    // MARK: Stored properties

    /// Unique identifier
    var uuid: UUID
    /// Name of the word set.
    var name: String
    /// Indicates whether or not case-sensitive comparison should be used for user's answers.
    var isCaseSensitive: Bool
    /// UUID of folder containing this word set
    var parentFolderUUID: UUID?

    // MARK: Computed properties

    // MARK: Initializers

    /// Creates an instance of `WordSet` class with given parameters.
    /// - Parameters:
    ///   - name: Name of the word set.
    ///   - isCaseSensitive: `true` if case-sensitive comparison should be used for words in this set,
    ///   `false` otherwise.
    init(name: String, isCaseSensitive: Bool) {
        self.uuid = UUID()
        self.name = name
        self.isCaseSensitive = isCaseSensitive
    }
}
