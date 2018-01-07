//
//  ObservationViewPresentation.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 06.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation

struct ObservationViewPresentation {
    
    let observation: Observation
    let name: String
    let confidence: String
    
    init(observation: Observation) {
        self.observation = observation
        self.name = observation.identifier
        self.confidence = String(describing: observation.confidence)
    }
}
