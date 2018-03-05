//
//  TranslatedObservationViewModel.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 13.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

struct TranslatedObservationViewModel {
    let image: UIImage?
    let confidance: String
    let targetLanguageId: LanguageId
    let translationViewModel: TranslationViewModel
    let translatedObservation: TranslatedObservation

    init(translatedObservation: TranslatedObservation,
         translationStore: TranslationStore,
         fromLanguage: Language,
         toLanguage: Language) {
        do {
            self.translatedObservation = translatedObservation
            self.image = UIImage(data: translatedObservation.imageData)?.rotate(byDegree: 90)
            self.confidance = ConfidanceFormatter.format(translatedObservation.confidence)
            self.targetLanguageId = toLanguage.id

            let translation = try translationStore.fetch(withFromLanguageId: fromLanguage.id,
                                                         andToLanguageId: toLanguage.id)
            self.translationViewModel = TranslationViewModel(fromWord: translation.fromWord,
                                                             fromLanguage: fromLanguage.name,
                                                             toWord: translation.toWord,
                                                             toLanguage: toLanguage.name)
        } catch {
            clog("Unable to create translationViewModel. Error: \(error)")
            fatalError()
        }
    }
}
