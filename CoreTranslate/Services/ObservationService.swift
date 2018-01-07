//
//  ObservationService.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 01.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit
import Vision

protocol ObservationServiceDelegate: class {
    func observationService(_ observationService: ObservationService, foundObservation observation: Observation)
}

final class ObservationService {

    let model: MLModel
    let eventQueue: DispatchQueue
    weak var delegate: ObservationServiceDelegate?
    private let observationTransformer: ObservationTransformer

    enum Error: Swift.Error {
        case cgImageMissing
    }

    private struct Constants {
        static let minimumConfidance: Float = 0.3
    }

    init(model: MLModel, eventQueue: DispatchQueue) {
        self.model = model
        self.eventQueue = eventQueue
        self.observationTransformer = ObservationTransformer()
    }

    func observeContent(of image: UIImage) throws {

        guard let cgImage = image.cgImage else {
            throw Error.cgImageMissing
        }

        // Get model from coreML model
        let visionCoreMLModel = try VNCoreMLModel(for: self.model)

        // Create request with the model and the specified completion handler

        let request = VNCoreMLRequest(model: visionCoreMLModel) { (request, error) in
            if let topObservation = request.results?.first as? VNClassificationObservation {
                let observation = self.observationTransformer.transform(topObservation)
                if observation.confidence >= Constants.minimumConfidance {
                    DispatchQueue.main.async {
                        self.delegate?.observationService(self, foundObservation: observation)
                    }
                }
            }
        }

        // Create request handler with cgImage and orientation specified
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))
        // TODO: Daniel - check out possible options to be passed in here
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: orientation!, options: [:])
        self.eventQueue.async { try? requestHandler.perform([request]) }
    }
}
