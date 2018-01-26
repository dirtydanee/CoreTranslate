//
//  LanguagesTransformer.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 24.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation

final class LanguagesTransformer {

    func transform(_ dictionaries:  [[String: String]]) throws -> [Language] {
        return dictionaries.flatMap {
            do {
                let encoder = JSONEncoder()
                let decoder = JSONDecoder()
                let encodedDictionary = try encoder.encode($0)
                return try decoder.decode(Language.self, from: encodedDictionary)
            } catch let error {
                // TODO: Handle error
                print(error)
                return nil
            }
        }

    }
}
