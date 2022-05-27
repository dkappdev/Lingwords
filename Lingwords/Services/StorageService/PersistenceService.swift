//
//  PersistenceService.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 27.05.2022.
//

import Foundation

protocol PersistenceServiceProtocol {
    func saveToFile<T: Encodable>(item: T)
    func loadFromFile<T: Decodable>(type: T.Type) -> T?
}

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
