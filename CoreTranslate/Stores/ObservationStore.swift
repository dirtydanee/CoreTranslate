//
//  ObservationStore.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 02.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

struct Observation: Equatable, Hashable {

    var hashValue: Int {
        return self.identifier.hashValue
    }

    let uuid: UUID
    let identifier: String
    let confidence: Float
    let capturedImageData: Data

    static func == (lhs: Observation, rhs: Observation) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

final class ObservationStore {

    private(set) var observations: Set<Observation> = []

    func add(_ observation: Observation) {
        self.observations.insert(observation)
    }
}
