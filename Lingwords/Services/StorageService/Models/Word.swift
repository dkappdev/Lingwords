//
//  Word.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 07.03.2022.
//

import Foundation

/// Instances of this class represent term-definition models.
struct Word: Codable {

    // MARK: Properties

    /// Unique identifier
    var uuid: UUID
    /// Term
    var term: String
    /// Definition
    var definition: String
    /// Indicates whether or not user finished learning this word
    var isCompleted: Bool

    /// UUID of word set containing this word
    var wordSetUUID: UUID?

    // MARK: Initializers

    init(term: String, definition: String, isCompleted: Bool) {
        self.uuid = UUID()
        self.term = term
        self.definition = definition
        self.isCompleted = isCompleted
    }
}
