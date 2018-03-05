//
//  TranslatedObservationTransformer.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 18.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation
import CoreData

final class TranslatedObservationTransformer: CoreDataTransformer {

    let context: NSManagedObjectContext
    let entityName: NSEntityDescription.CoreTranslationEntityName
    private let wordTransformer: WordTransfromer
    private let translationTransformer: TranslationTransformer

    init(context: NSManagedObjectContext,
         entityName: NSEntityDescription.CoreTranslationEntityName) {
        self.context = context
        self.entityName = entityName
        self.wordTransformer = WordTransfromer(context: context, entityName: .word)
        self.translationTransformer = TranslationTransformer(context: context, entityName: .translation)
    }

    func transform(_ observation: Observation,
                   languages: TranslationLanguageSpecifier,
                   translatedValue: String) -> TranslatedObservation {

        let translatedObservation = TranslatedObservation(entity: self.entityDescription, insertInto: self.context)
        translatedObservation.createdAt = Date()
        translatedObservation.imageData = observation.capturedImageData
        translatedObservation.confidence = observation.confidence

        let fromWord = self.wordTransformer.transform(languageId: languages.from.id, value: observation.identifier)
        let toWord = self.wordTransformer.transform(languageId: languages.to.id, value: translatedValue)
        let translation = self.translationTransformer.transform(fromWord: fromWord,
                                                                toWord: toWord,
                                                                isMaster: true) // TODO: Check if it is really master
        translation.translatedObservation = translatedObservation
        let translations: Set<Translation> = [translation]
        translatedObservation.translations = translations

        return translatedObservation
    }
}
