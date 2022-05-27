//
//  Item.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 07.03.2022.
//

import Foundation

enum Item {
    case word(Word)
    case wordSet(WordSet)
    case folder(Folder)

    var uuid: UUID {
        switch self {
        case .word(let word):
            return word.uuid
        case .wordSet(let wordSet):
            return wordSet.uuid
        case .folder(let folder):
            return folder.uuid
        }
    }

    var parentUUID: UUID? {
        switch self {
        case .word(let word):
            return word.wordSetUUID
        case .wordSet(let wordSet):
            return wordSet.parentFolderUUID
        case .folder(let folder):
            return folder.parentFolderUUID
        }
    }
}

// MARK: - Hashable

extension Item: Hashable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        switch (lhs, rhs) {
        case let (.word(leftWord), .word(rightWord)):
            return leftWord.uuid == rightWord.uuid
        case let (.wordSet(leftWordSet), .wordSet(rightWordSet)):
            return leftWordSet.uuid == rightWordSet.uuid
        case let (.folder(leftFolder), .folder(rightFolder)):
            return leftFolder.uuid == rightFolder.uuid
        default:
            return false
        }
    }

    func hash(into hasher: inout Hasher) {
        switch self {
        case .word(let word):
            hasher.combine(word.uuid)
        case .wordSet(let wordSet):
            hasher.combine(wordSet.uuid)
        case .folder(let folder):
            hasher.combine(folder.uuid)
        }
    }
}

// MARK: - Codable

extension Item: Codable { }
