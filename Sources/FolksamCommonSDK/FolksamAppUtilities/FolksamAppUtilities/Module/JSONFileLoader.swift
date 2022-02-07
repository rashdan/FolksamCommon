//
//  JSONFileLoader.swift
//  FolksamAppUtilities
//
//  Created by Johan Torell on 2021-11-09.
//

import Foundation

public func loadJSONFile<T: Decodable>(_ filename: String, bundle: Bundle) -> T {
    let data: Data

    guard let file = bundle.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
