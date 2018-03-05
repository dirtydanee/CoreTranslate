//
//  WordTransfromer.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 04.03.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import CoreData

final class WordTransfromer: CoreDataTransformer {
    let context: NSManagedObjectContext
    let entityName: NSEntityDescription.CoreTranslationEntityName

    init(context: NSManagedObjectContext, entityName:  NSEntityDescription.CoreTranslationEntityName) {
        self.context = context
        self.entityName = entityName
    }

    func transform(languageId: LanguageId,
                   value: String) -> Word {
        let word = Word(entity: self.entityDescription, insertInto: self.context)
        word.identifier = UUID()
        word.value = value
        word.languageId = languageId.rawValue

        return word
    }
}
