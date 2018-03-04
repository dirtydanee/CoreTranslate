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

    // TODO: Move this to settings
    private struct Constants {
        static let minimumConfidance: Float = 0.3
    }

    enum Error: Swift.Error {
        case imageToDataConversionFailed
        case unqualifiedImage
    }

    let observationStore: ObservationStore
    let context: NSManagedObjectContext
    let entityName: NSEntityDescription.CoreTranslationEntityName
    let languageStore: LanguageStore

    init(observationStore: ObservationStore,
         entityName: NSEntityDescription.CoreTranslationEntityName,
         languageStore: LanguageStore) {
        self.observationStore = observationStore
        self.context = observationStore.context
        self.entityName = entityName
        self.languageStore = languageStore
    }

    func transform(_ classificationObservation: VNClassificationObservation,
                   from image: UIImage) throws -> Observation {

        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
            throw Error.imageToDataConversionFailed
        }

        guard classificationObservation.confidence >= Constants.minimumConfidance,
              !observationStore.exists(identifier: classificationObservation.identifier) else {
            throw Error.unqualifiedImage
        }

        let observation = Observation(entity: self.entityDescription, insertInto: self.context)

        observation.createdAt = Date()
        observation.uuid = classificationObservation.uuid.uuidString
        observation.identifier = classificationObservation.identifier
        let confidence: Float = classificationObservation.confidence
        observation.confidence = confidence
        observation.capturedImageData = imageData
        observation.baseLanguageId = ApplicationConfiguration.baseLanguageId.rawValue

        return observation
    }
}
