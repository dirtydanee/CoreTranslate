//
//  ObservationService.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 01.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit
import Vision
import CoreData

final class ObservationService {

    enum Error: Swift.Error {
        case missingCGImage
        case invalidOrientation
        case invalidStructure
        case missingModel
    }

    let model: MLModel
    let eventQueue: DispatchQueue
    private let observationTransformer: ObservationTransformer
    private let visionCoreMLModel: VNCoreMLModel?
    private var counter: Int = 0

    init(model: MLModel,
         eventQueue: DispatchQueue,
         observationStore: ObservationStore,
         languageStore: LanguageStore) {
        self.model = model
        self.visionCoreMLModel = try? VNCoreMLModel(for: model)
        self.eventQueue = eventQueue
        self.observationTransformer = ObservationTransformer(observationStore: observationStore,
                                                             entityName: .observation,
                                                             languageStore: languageStore)
    }

    func observeContent(of image: UIImage, completionHandler: ((Result<Observation>) -> Swift.Void)?) throws {

        guard let cgImage = image.cgImage else {
            throw Error.missingCGImage
        }

        guard let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue)) else {
            throw Error.invalidOrientation
        }

        guard let visionCoreMLModel = self.visionCoreMLModel else {
            throw Error.missingModel
        }

        // Create request with the model and the specified completion handler
        // TODO: Daniel - try to zoom in on the recognized object on the picture
        let request = VNCoreMLRequest(model: visionCoreMLModel) { request, error in

            DispatchQueue.main.async {

                guard error == nil else {
                    completionHandler?(.failure(error!))
                    return
                }

                guard let topObservation = request.results?.first as? VNClassificationObservation else {
                    completionHandler?(.failure(Error.invalidStructure))
                    return
                }
                // TODO: Move this to the coordinator
                if let observation = try? self.observationTransformer.transform(topObservation, from: image) {
                    completionHandler?(.success(observation))
                }
            }
        }

        let requestHandler: VNImageRequestHandler = VNImageRequestHandler(cgImage: cgImage,
                                                                          orientation: orientation,
                                                                          options: [:])
        self.eventQueue.async { try? requestHandler.perform([request]) }
    }
}
