//
//  ClassificationViewPresentation.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 06.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

struct ObservationViewPresentation {
    
    let observation: Observation
    let resultTitle: String
    let resultValue: String
    let confidenceTitle: String
    let confidenceValue: String
    let image: UIImage?
    
    init(observation: Observation) {
        self.observation = observation
        self.resultTitle = "Result:" // TODO: Localize
        self.resultValue = observation.identifier
        self.confidenceTitle = "Confidence:"
        self.confidenceValue = ConfidanceFormatter.format(observation.confidence)
        self.image = UIImage(data: observation.capturedImageData)
    }
}

struct ConfidanceFormatter {

    static func format(_ value: Float) -> String {
        let formatter = NumberFormatter()
        formatter.alwaysShowsDecimalSeparator = true
        formatter.maximumFractionDigits = 2
        return formatter.string(for: value) ?? ""
    }

}
