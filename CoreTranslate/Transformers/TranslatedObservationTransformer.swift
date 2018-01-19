//
//  TranslatedObservationTransformer.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 18.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation

final class TranslatedObservationTransformer {

    func transform(_ observation: Observation,
                   languages: TranslationLanguageSpecifier,
                   translatedValue: String) -> TranslatedObservation {
        let fromWord = Translation.Word(value: observation.identifier, language: languages.from)
        let toWord = Translation.Word(value: translatedValue, language: languages.to)
        let translation = Translation.init(from: fromWord, to: toWord)
        let translatedObservation = TranslatedObservation(observation: observation, translations: [translation])

        return translatedObservation
    }
}
