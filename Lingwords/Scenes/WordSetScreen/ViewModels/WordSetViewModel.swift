//
//  WordSetViewModel.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 04.06.2022.
//

import Foundation

/// View model used for WordSet scene
struct WordSetViewModel {

    // MARK: Nested types

    struct Word {

        let uuid: UUID
        let term: String
        let definition: String
        let isCompleted: Bool
    }

    // MARK: Properties

    var uuid: UUID
    var name: String
    var words: [Self.Word]
}
