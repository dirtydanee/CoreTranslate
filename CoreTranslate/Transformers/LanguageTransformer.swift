//
//  LanguageTransformer.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 24.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import CoreData

final class LanguageTransformer: CoreDataTransformer {

    let context: NSManagedObjectContext
    let entityName: NSEntityDescription.CoreTranslationEntityName

    init(context: NSManagedObjectContext, entityName:  NSEntityDescription.CoreTranslationEntityName) {
        self.context = context
        self.entityName = entityName
    }

    func transform(_ dictionaries: [[String: Any]]) throws {

        return dictionaries.forEach { dictionary in
                guard let id = dictionary["id"] as? String,
                    let flagHexValues = dictionary["flagHexValues"] as? [Int],
                    let name = dictionary["name"] as? String else {
                        return
                }

                var flag: String = ""
                flagHexValues.forEach { hexValue in
                    if let scalar = UnicodeScalar(hexValue) {
                        flag.append(Character(scalar))
                    }
                }

                let language = Language(entity: self.entityDescription, insertInto: self.context)
                language.rawId = id
                language.flag = flag
                language.name = name
        }
    }
}
