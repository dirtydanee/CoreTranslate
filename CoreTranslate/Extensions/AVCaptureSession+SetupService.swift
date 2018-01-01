//
//  CaptureSessionSetupInteractor.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 22.12.17.
//  Copyright © 2017 Dirtylabs. All rights reserved.
//

import AVFoundation

extension AVCaptureSession {

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

    func setupCamera(for mediaType: AVMediaType,
                     position: AVCaptureDevice.Position,
                     devicetypes: [AVCaptureDevice.DeviceType],
                     sampleBufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate?) throws {

        let device = try self.device(for: devicetypes, mediaType: mediaType, position: position)
        let input = try AVCaptureDeviceInput(device: device)

        guard self.canAddInput(input) else {
            throw Error.Setup.invalidDeviceInput
        }

        self.addInput(input)

        let photoOutput = AVCapturePhotoOutput()

        guard self.canAddOutput(photoOutput) else {
            throw Error.Setup.invalidPhotoOutput
        }

        self.addOutput(photoOutput)

        let videoDataOutput = AVCaptureVideoDataOutput()
        let vidooDataOutputQueue = DispatchQueue(label: "com.dirtylabs.coretranslate.vidooDataOutputQueue")
        videoDataOutput.setSampleBufferDelegate(sampleBufferDelegate, queue: vidooDataOutputQueue)

        guard self.canAddOutput(videoDataOutput) else {
            throw Error.Setup.invalidDataOutput
        }

        self.addOutput(videoDataOutput)
    }

    func updatePosition(for devicetypes: [AVCaptureDevice.DeviceType], mediaType: AVMediaType, position: AVCaptureDevice.Position) throws {

        guard let currentInput = self.inputs.first else {
            throw Error.CameraFlip.noInputsDetected
        }

        self.beginConfiguration()
        defer {
            self.commitConfiguration()
        }

        let device = try self.device(for: devicetypes, mediaType: mediaType, position: position)
        let newInput = try AVCaptureDeviceInput(device: device)
        self.removeInput(currentInput)
        self.addInput(newInput)
    }

    private func device(for devicetypes: [AVCaptureDevice.DeviceType], mediaType: AVMediaType, position: AVCaptureDevice.Position) throws -> AVCaptureDevice {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: devicetypes,
                                                                mediaType: mediaType,
                                                                position: position)

        guard let device = discoverySession.devices.first else {
            throw Error.DeviceDiscovery.unfoundDevice
        }

        return device
    }
}
