//
//  ObservationTransformer.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 02.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit
import Vision

final class ObservationTransformer {

    enum Error: Swift.Error {
        case imageToDataConversionFailed
    }

    func transform(_ classificationObservation: VNClassificationObservation, from image: UIImage) throws -> Observation {

        guard let imageData = UIImagePNGRepresentation(image) else {
            throw Error.imageToDataConversionFailed
        }

        let observation = Observation(uuid: classificationObservation.uuid,
                                      identifier: classificationObservation.identifier,
                                      confidence: classificationObservation.confidence,
                                      capturedImageData: imageData)
        return observation
    }
}
