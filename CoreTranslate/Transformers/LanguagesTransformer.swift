//
//  LanguagesTransformer.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 24.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation

final class LanguagesTransformer {

    enum Error: Swift.Error {
        case invalidLanguageID(id: String)
    }

    func transform(_ dictionaries:  [[String: Any]]) throws -> [Language] {

        return dictionaries.flatMap { dictionary in
            do {
                guard let id = dictionary["id"] as? String,
                    let flagHexValues = dictionary["flagHexValues"] as? [Int],
                    let humanReadable = dictionary["name"] as? String else {
                        return nil
                }

                guard let languageId = LanguageId(rawValue: id) else {
                    throw LanguagesTransformer.Error.invalidLanguageID(id: id)
                }

                var flag: String = ""
                flagHexValues.forEach { hexValue in
                    if let scalar = UnicodeScalar(hexValue) {
                        flag.append(Character(scalar))
                    }
                }

                return Language(id: languageId, flag: flag, humanReadable: humanReadable)
            } catch let error {
                // TODO: Handle error
                print(error)
                return nil
            }
        }
    }
}
