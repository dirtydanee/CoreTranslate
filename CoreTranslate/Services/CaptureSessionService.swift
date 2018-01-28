//
//  CaptureSessionService.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 13.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import AVFoundation
import UIKit

final class CaptureSessionService: NSObject {

    enum Error {
        enum Setup: Swift.Error {
            case invalidDeviceInput
            case invalidPhotoOutput
            case invalidDataOutput
        }

        enum CameraFlip: Swift.Error {
            case noInputsDetected
        }

        enum DeviceDiscovery: Swift.Error {
            case unfoundDevice
        }

        enum CapturePhoto: Swift.Error {
            case missingDevice
            case missingPhotoOutput
            case unableToGetFileData
        }
    }

    let captureSession: AVCaptureSession
    private(set) var isCaptureSessionSetup: Bool
    private var lastUsedCaptureDevice: AVCaptureDevice?
    private var photoOutput: AVCapturePhotoOutput?
    private var videoDataOutput: AVCaptureVideoDataOutput?
    private var capturePhotoHandler: CapturePhotoHandler?
    typealias CapturePhotoHandler = (Result<UIImage>) -> Swift.Void

    init(captureSession: AVCaptureSession) {
        self.captureSession = captureSession
        self.isCaptureSessionSetup = false
    }

    func setupCamera(for mediaType: AVMediaType,
                     position: AVCaptureDevice.Position,
                     devicetypes: [AVCaptureDevice.DeviceType],
                     sampleBufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate?) throws {

        let device = try self.device(for: devicetypes, mediaType: mediaType, position: position)
        let input = try AVCaptureDeviceInput(device: device)

        guard self.captureSession.canAddInput(input) else {
            throw Error.Setup.invalidDeviceInput
        }

        self.captureSession.addInput(input)

        let photoOutput = AVCapturePhotoOutput()
        guard self.captureSession.canAddOutput(photoOutput) else {
            throw Error.Setup.invalidPhotoOutput
        }

        photoOutput.isHighResolutionCaptureEnabled = true
        self.captureSession.addOutput(photoOutput)
        self.photoOutput = photoOutput

        let videoDataOutput = AVCaptureVideoDataOutput()
        let vidooDataOutputQueue = DispatchQueue.makeQueue(for: AVCaptureVideoDataOutput.self)
        videoDataOutput.setSampleBufferDelegate(sampleBufferDelegate, queue: vidooDataOutputQueue)

        guard self.captureSession.canAddOutput(videoDataOutput) else {
            throw Error.Setup.invalidDataOutput
        }

        self.captureSession.addOutput(videoDataOutput)
        self.videoDataOutput = videoDataOutput

        self.lastUsedCaptureDevice = device
        self.isCaptureSessionSetup = true
    }

    func updatePosition(for devicetypes: [AVCaptureDevice.DeviceType],
                        mediaType: AVMediaType,
                        position: AVCaptureDevice.Position) throws {

        guard let currentInput = self.captureSession.inputs.first else {
            throw Error.CameraFlip.noInputsDetected
        }

        self.captureSession.beginConfiguration()
        defer {
            self.captureSession.commitConfiguration()
        }

        let device = try self.device(for: devicetypes, mediaType: mediaType, position: position)
        let newInput = try AVCaptureDeviceInput(device: device)
        self.captureSession.removeInput(currentInput)
        self.captureSession.addInput(newInput)
        self.lastUsedCaptureDevice = device
    }

    func updateTorch() {
        // Can turn on torch only when back camera is active
        guard let device = self.lastUsedCaptureDevice, device.position == .back else { return }
        let active = device.isTorchActive
        do {
            try device.lockForConfiguration()
            if active {
                device.torchMode = .off
            } else {
                try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
            }
            device.unlockForConfiguration()
        } catch {
            print("Failed to set camera torchMode to '\(active)'. Error: \(error as NSError)")
        }
    }

    func capturePhoto(handler: @escaping CapturePhotoHandler) throws {

        guard let device = lastUsedCaptureDevice else {
            throw Error.CapturePhoto.missingDevice
        }

        guard let photoOutput = self.photoOutput else {
            throw Error.CapturePhoto.missingPhotoOutput
        }

        self.capturePhotoHandler = handler

        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isHighResolutionPhotoEnabled = true
        if device.isFlashAvailable {
            photoSettings.flashMode = .auto
        }
        // TODO:
        print(photoSettings.availablePreviewPhotoPixelFormatTypes)
        if let highestPixelFormat = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: highestPixelFormat]
        }

        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }

    private func device(for devicetypes: [AVCaptureDevice.DeviceType],
                        mediaType: AVMediaType,
                        position: AVCaptureDevice.Position) throws -> AVCaptureDevice {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: devicetypes,
                                                                mediaType: mediaType,
                                                                position: position)

        guard let device = discoverySession.devices.first else {
            throw Error.DeviceDiscovery.unfoundDevice
        }

        return device
    }
}

// MARK: - AVCapturePhotoCaptureDelegate Methods

extension CaptureSessionService: AVCapturePhotoCaptureDelegate {

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Swift.Error?) {

        guard let capturePhotoHandler = self.capturePhotoHandler else {
            return
        }

        if let error = error {
            capturePhotoHandler(.failure(error))
            return
        }

        guard let data = photo.fileDataRepresentation(),
              let image =  UIImage(data: data)  else {
                capturePhotoHandler(.failure(Error.CapturePhoto.unableToGetFileData))
                return
        }

        capturePhotoHandler(.success(image))
        self.capturePhotoHandler = nil
    }
}
