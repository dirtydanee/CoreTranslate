//
//  ObservationStore.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 02.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

typealias ObservationIdentifier = String

struct Observation: Equatable, Hashable {

    var hashValue: Int {
        return self.identifier.hashValue
    }

    let uuid: UUID
    let identifier: ObservationIdentifier
    let confidence: Float

    static func ==(lhs: Observation, rhs: Observation) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

final class ObservationStore {

    private(set) var observations: Set<Observation> = []

    func add(_ observation: Observation, asUnique unique: Bool = true) {
        self.observations.insert(observation)
    }
}
