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
    let translationViewPresentations: [TranslationViewModel]
    let translatedObservation: TranslatedObservation

    init(translatedObservation: TranslatedObservation, toTargetLanguage: Language) {
        self.translatedObservation = translatedObservation
        self.image = UIImage(data: translatedObservation.observation.capturedImageData)?.rotate(byDegree: 90)
        self.confidance = ConfidanceFormatter.format(translatedObservation.observation.confidence)
        self.targetLanguageId = toTargetLanguage.id
        self.translationViewPresentations = translatedObservation.translations
                                                                 .map { TranslationViewModel(translation: $0) }
    }
}
