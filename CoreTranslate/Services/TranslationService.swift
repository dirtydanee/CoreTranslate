//
//  TranslationService.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 08.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation
import CoreData

protocol TranslationServiceDelegate: class {
    func translationService(_ translationService: TranslationService,
                            didTranslateObservation translatedObservation: TranslatedObservation)

    func translationService(_ translationService: TranslationService,
                            didFailCreatingTranslationFor observation: Observation,
                            with error: Error)
}

final class TranslationService {

    let baseURL: URL
    let context: NSManagedObjectContext
    weak var delegate: TranslationServiceDelegate?
    private let restService: RESTService
    private let translationsOpertionQueue: OperationQueue
    private let translatedObservationTransformer: TranslatedObservationTransformer

    init(baseURL: URL, context: NSManagedObjectContext) {
        self.baseURL = baseURL
        self.context = context
        self.restService = RESTService(baseURL: baseURL)
        self.translationsOpertionQueue = OperationQueue()
        self.translatedObservationTransformer = TranslatedObservationTransformer(context: context,
                                                                        entityName: .translatedObservation)
    }

    func translate(observation: Observation,
                   fromLanguage: Language,
                   toLanguage: Language) {
        let languageSpecifier = TranslationLanguageSpecifier(from: fromLanguage, to: toLanguage)
        let operation = TranslationOperation(observation: observation,
                                             languageSpecifier: languageSpecifier,
                                             restService: self.restService)
        operation.delegate = self
        self.translationsOpertionQueue.addOperation(operation)
    }
}

extension TranslationService: TranslationOperationDelegate {
    func translationOperation(_ translationOperation: TranslationOperation,
                              didFinishExecutingWithResult result: Result<TranslationResponse>) {
        DispatchQueue.main.async {
            switch result {
            case .failure(let error):
                self.delegate?.translationService(self,
                                                  didFailCreatingTranslationFor: translationOperation.observation,
                                                  with: error)
            case .success(let response):
                let translatedObservation = self.translatedObservationTransformer
                                            .transform(translationOperation.observation,
                                                       languages: translationOperation.languageSpecifier,
                                                       translatedValue: response.text)
                self.delegate?.translationService(self, didTranslateObservation: translatedObservation)
            }
        }
    }
}
