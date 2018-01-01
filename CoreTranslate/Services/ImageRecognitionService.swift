//
//  ImageRecognitionService.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 01.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit
import Vision

final class ImageRecognitionService {

    let model: MLModel
    let eventQueue: DispatchQueue

    init(model: MLModel, eventQueue: DispatchQueue) {
        self.model = model
        self.eventQueue = eventQueue
    }

    func recognizeContent(of image: UIImage) {
        // Get model from coreML model
        guard let visionCoreMLModel = try? VNCoreMLModel(for: self.model),
              let cgImage = image.cgImage else {
                fatalError()
        }

        // Create request with the model and the specified completion handler
        let request = VNCoreMLRequest(model: visionCoreMLModel, completionHandler: self.handlePredictionCompletionHandler)

        // Create request handler with cgImage and orientation specified
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))
        // TODO: Daniel - check out possible options to be passed in here
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: orientation!, options: [:])
        self.eventQueue.async {
            try? requestHandler.perform([request])
        }
    }

    /// Note - syntax is the same as VNRequestCompletionHandler
    // TODO: Daniel - experiment what other options are there for handling  the guess
    func handlePredictionCompletionHandler(for request: VNRequest, error: Error?) {
        if let topObservation = request.results?.first as? VNClassificationObservation {
            print(topObservation.identifier)
        }
    }
}
