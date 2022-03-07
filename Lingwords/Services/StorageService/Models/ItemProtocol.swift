//
//  ItemProtocol.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 07.03.2022.
//

import Foundation

/// Protocol to which storage items should conform.
/// In current implementation both `WordSet` and `Folder` conform to `ItemProtocol`,
/// which allows for creation of nested folders,
public protocol ItemProtocol {

    var uuid: UUID { get }
}
