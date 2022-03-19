//
//  ItemProtocol.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 07.03.2022.
//

import Foundation

/// Protocol for identifiable items
public protocol ItemProtocol {

    /// Item identifier
    var uuid: UUID { get }
}
