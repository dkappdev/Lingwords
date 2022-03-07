//
//  Word.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 07.03.2022.
//

import Foundation

public class Word: ItemProtocol {

    public var uuid = UUID()
    public var term: String
    public var definition: String
    public var isCompleted: Bool

    public weak var wordSet: WordSet?

    public init(term: String, definition: String, isCompleted: Bool, wordSet: WordSet?) {
        self.term = term
        self.definition = definition
        self.isCompleted = isCompleted
        self.wordSet = wordSet
    }
}
