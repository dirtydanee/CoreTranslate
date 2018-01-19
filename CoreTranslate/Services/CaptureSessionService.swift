//
//  CaptureSessionService.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 13.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import AVFoundation

final class CaptureSessionService {

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
    }

    let captureSession: AVCaptureSession
    private(set) var isCaptureSessionSetup: Bool
    private var lastUsedCaptureDevice: AVCaptureDevice?

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

        self.captureSession.addOutput(photoOutput)

        let videoDataOutput = AVCaptureVideoDataOutput()
        let vidooDataOutputQueue = DispatchQueue.makeQueue(for: AVCaptureVideoDataOutput.self)
        videoDataOutput.setSampleBufferDelegate(sampleBufferDelegate, queue: vidooDataOutputQueue)

        guard self.captureSession.canAddOutput(videoDataOutput) else {
            throw Error.Setup.invalidDataOutput
        }

        self.captureSession.addOutput(videoDataOutput)

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
