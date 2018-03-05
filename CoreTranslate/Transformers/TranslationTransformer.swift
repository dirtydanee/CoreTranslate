//
//  TranslationTransformer.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 04.03.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import CoreData

final class TranslationTransformer: CoreDataTransformer {
    let context: NSManagedObjectContext
    let entityName: NSEntityDescription.CoreTranslationEntityName

    init(context: NSManagedObjectContext, entityName: NSEntityDescription.CoreTranslationEntityName) {
        self.context = context
        self.entityName = entityName
    }

    func transform(fromWord: Word,
                   toWord: Word,
                   isMaster: Bool) -> Translation {

        let translation = Translation(entity: self.entityDescription, insertInto: self.context)
        translation.fromWord = fromWord
        translation.toWord = toWord
        translation.isMaster = isMaster

        fromWord.translation = translation
        //toWord.translation = translation // TODO: Why does setting this will fuck up the core data stuff

        return translation
    }
}
