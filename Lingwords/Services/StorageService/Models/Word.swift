//
//  Word.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 07.03.2022.
//

import Foundation

/// Instances of this class represent term-definition models.
public class Word: ItemProtocol {

    /// Unique identifier
    public var uuid = UUID()
    /// Term
    public var term: String
    /// Definition
    public var definition: String
    /// Indicates whether or not user finished learning this word
    public var isCompleted: Bool

    /// Word set which contains this word
    public weak var wordSet: WordSet?

    public init(term: String, definition: String, isCompleted: Bool, wordSet: WordSet?) {
        self.term = term
        self.definition = definition
        self.isCompleted = isCompleted
        self.wordSet = wordSet
    }
}
