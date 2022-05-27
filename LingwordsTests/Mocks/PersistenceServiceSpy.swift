//
//  PersistenceServiceSpy.swift
//  LingwordsTests
//
//  Created by Daniil Kostitsin on 27.05.2022.
//

@testable import Lingwords

final class PersistenceServiceSpy: PersistenceServiceProtocol {
    private(set) var saveToFileCalled = false
    private(set) var passedItem: Any!

    private(set) var loadFromFileCalled = false
    private(set) var passedType: Any.Type!
    var returnedItem: Any?

    func saveToFile<T: Encodable>(item: T) {
        saveToFileCalled = true
        passedItem = item
    }

    func loadFromFile<T: Decodable>(type: T.Type) -> T? {
        loadFromFileCalled = true
        passedType = type
        return returnedItem as? T
    }
}
