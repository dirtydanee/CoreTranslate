//
//  ObservationTransformer.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 02.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit
import CoreData
import Vision

final class ObservationTransformer: CoreDataTransformer {

    enum Error: Swift.Error {
        case imageToDataConversionFailed
    }

    let context: NSManagedObjectContext
    let entityName: NSEntityDescription.CoreTranslationEntityName
    let languageStore: LanguageStore

    init(context: NSManagedObjectContext,
         entityName: NSEntityDescription.CoreTranslationEntityName,
         languageStore: LanguageStore) {
        self.context = context
        self.entityName = entityName
        self.languageStore = languageStore
    }

    func transform(_ classificationObservation: VNClassificationObservation,
                   from image: UIImage) throws -> Observation {

        guard let imageData = UIImagePNGRepresentation(image) else {
            throw Error.imageToDataConversionFailed
        }

        let observation = Observation(entity: self.entityDescription, insertInto: self.context)

        observation.createdAt = Date()
        observation.uuid = classificationObservation.uuid.uuidString
        observation.identifier = classificationObservation.identifier
        let confidence: Float = classificationObservation.confidence
        observation.confidence = confidence
        observation.capturedImageData = imageData
        observation.baseLanguage = self.languageStore.language(with: ApplicationConfiguration.baseLanguage)

        return observation
    }
}
