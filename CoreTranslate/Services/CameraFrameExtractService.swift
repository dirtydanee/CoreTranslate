//
//  CameraFrameExtractService.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 22.12.17.
//  Copyright © 2017 Dirtylabs. All rights reserved.
//

import AVFoundation
import UIKit

protocol CameraFrameExtractServiceDelegate: class {
    func cameraFrameExtractService(_ cameraFrameExtractService: CameraFrameExtractService, didExtractImage image: UIImage)
}

final class CameraFrameExtractService: NSObject {

    enum Error: Swift.Error {
        case failedCreatingImageBuffer
        case failedCreatingCGImage
    }

    struct Constants {
        static let presentQuality: AVCaptureSession.Preset = .medium
    }

    let captureSession: AVCaptureSession
    let context: CIContext
    weak var delegate: CameraFrameExtractServiceDelegate?

    init(captureSession: AVCaptureSession,
         delegate: CameraFrameExtractServiceDelegate?) {
        self.captureSession = captureSession
        self.context = CIContext()
        self.captureSession.sessionPreset = Constants.presentQuality
    }

    private func image(from sampleBuffer: CMSampleBuffer) throws -> UIImage {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            throw Error.failedCreatingImageBuffer
        }

        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = self.context.createCGImage(ciImage, from: ciImage.extent) else {
            throw Error.failedCreatingCGImage
        }
        return UIImage(cgImage: cgImage)
    }
}

extension CameraFrameExtractService: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        do {
            let image = try self.image(from: sampleBuffer)
            DispatchQueue.main.async {
                self.delegate?.cameraFrameExtractService(self, didExtractImage: image)
            }
        } catch let error {
            // TODO: Daniel - add error handling
            print(error)
        }
    }
}
