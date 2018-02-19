//
//  LanguagesTransformer.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 24.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation
import CoreData

final class LanguagesTransformer {

    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func transform(_ dictionaries:  [[String: Any]]) throws -> [Language] {

        return dictionaries.flatMap { dictionary in
                guard let id = dictionary["id"] as? String,
                    let flagHexValues = dictionary["flagHexValues"] as? [Int],
                    let name = dictionary["name"] as? String else {
                        return nil
                }

                var flag: String = ""
                flagHexValues.forEach { hexValue in
                    if let scalar = UnicodeScalar(hexValue) {
                        flag.append(Character(scalar))
                    }
                }

                let entityDescription = NSEntityDescription.entity(forEntityName: "Language", in: self.context)
                let language = Language(entity: entityDescription!, insertInto: self.context) // TODO: Fix me
                language.rawId = id
                language.flag = flag
                language.name = name

                return language
        }
    }
}
