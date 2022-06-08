//
//  PersistenceService.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 27.05.2022.
//

import Foundation

/// A set of methods that a persistence service should implement
protocol PersistenceServiceProtocol {

    /// Saves specified item to disk
    /// - Parameter item: Item to save. Instance passed to the method should conform to `Decodable`
    func saveToFile<T: Encodable>(item: T)

    /// Loads item of specified type from disk
    /// - Parameter type: Type of the item to load.
    /// - Returns: Item loaded from disk. `nil` if unsuccessful.
    func loadFromFile<T: Decodable>(type: T.Type) -> T?
}

/// Concrete persistence service implementation. Instances of this class are responsible for storing data on disk.
final class PersistenceService: PersistenceServiceProtocol {

    private let fileURL = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)
        .first?
        .appendingPathComponent("userData")
        .appendingPathExtension("json")

    func saveToFile<T: Encodable>(item: T) {
        guard let fileURL = fileURL else {
            print("ERROR: Failed to save user data – file URL does not exist")
            return
        }

        do {
            let data = try JSONEncoder().encode(item)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("ERROR: \(error)")
        }
    }

    func loadFromFile<T: Decodable>(type: T.Type) -> T? {
        guard let fileURL = fileURL else {
            print("ERROR: Failed to read user data – file URL does not exist")
            return nil
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let item = try JSONDecoder().decode(T.self, from: data)
            return item
        } catch {
            print("ERROR: \(error)")
            return nil
        }
    }
}
