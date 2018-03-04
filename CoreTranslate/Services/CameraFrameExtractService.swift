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
    func cameraFrameExtractService(_ cameraFrameExtractService: CameraFrameExtractService,
                                   didExtractImage image: UIImage)
}

final class CameraFrameExtractService: NSObject {

    enum Error: Swift.Error {
        case failedCreatingImageBuffer
        case failedCreatingCGImage
    }

    struct Constants {
        static let presentQuality: AVCaptureSession.Preset = .high
    }

    let captureSession: AVCaptureSession
    let extractionInterval: TimeInterval
    weak var delegate: CameraFrameExtractServiceDelegate?
    private let context: CIContext
    private(set) var isRunning: Bool
    private var timer: Timer?
    private var imageQueue: [UIImage]

    init(captureSession: AVCaptureSession,
         extractionInterval: TimeInterval = 0.2) {
        self.captureSession = captureSession
        self.extractionInterval = extractionInterval
        self.context = CIContext()
        self.captureSession.sessionPreset = Constants.presentQuality
        self.isRunning = false
        self.timer = Timer()
        self.imageQueue = []
    }

    // MARK: Public API

    func startExtractingVideoFrames() {
        self.isRunning = true
        self.timer = Timer.init(timeInterval: self.extractionInterval, repeats: true, block: self.timerCompletionBlock)
        RunLoop.current.add(self.timer!, forMode: RunLoopMode.defaultRunLoopMode)
    }

    func stopExtractingVideoFrames() {
        self.isRunning = false
        self.timer?.invalidate()
        self.timer = nil
    }
}

// MARK: Private API

private extension CameraFrameExtractService {

    private func timerCompletionBlock(timer: Timer) {
        weak var weakSelf = self
        guard let strongSelf = weakSelf,
            let lastImage = strongSelf.imageQueue.last else {
                return
        }
        strongSelf.imageQueue.removeAll()
        DispatchQueue.main.async {
            strongSelf.delegate?.cameraFrameExtractService(strongSelf, didExtractImage: lastImage)
        }
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

// MARK: AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraFrameExtractService: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {

        guard self.isRunning else {
            return
        }

        do {
            let image = try self.image(from: sampleBuffer)
            self.imageQueue.append(image)
        } catch {
            // TODO: Daniel - add error handling
            clog("\(error)")
        }
    }
}
