//
//  ObservationTransformer.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 02.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation
import Vision

final class ObservationTransformer {

    func transform(_ classificationObservation: VNClassificationObservation) -> Observation {
        let observation = Observation(uuid: classificationObservation.uuid,
                                      identifier: classificationObservation.identifier,
                                      confidence: classificationObservation.confidence)
        return observation
    }
}
