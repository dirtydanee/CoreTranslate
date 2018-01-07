//
//  TakePhotoCoordinator.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 10.12.17.
//  Copyright © 2017 Dirtylabs. All rights reserved.
//

import UIKit
import AVFoundation

protocol TakePhotoView: class {
    func addCameraView()
}

final class TakePhotoCoordinator: Coordinator {

    struct Constants {
        struct Video {
            static let type: AVMediaType = .video
        }

        struct Device {
            static let position: AVCaptureDevice.Position = .back
            static let types: [AVCaptureDevice.DeviceType] = [.builtInWideAngleCamera]
        }
    }

    let navigationController: UINavigationController
    private(set) var childCoordinators: [Coordinator]

    private let captureSession: AVCaptureSession
    private let captureSessionService: CaptureSessionService
    private let captureSessionQueue: DispatchQueue
    private let cameraFrameExtractService: CameraFrameExtractService & AVCaptureVideoDataOutputSampleBufferDelegate
    private let observationService: ObservationService
    private let observationStore: ObservationStore
    private var takePhotoView: TakePhotoView?
    private var currentCameraPosition = Constants.Device.position

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []

        let captureSession = AVCaptureSession()
        self.cameraFrameExtractService = CameraFrameExtractService(captureSession: captureSession, delegate: nil)
        self.captureSessionService = CaptureSessionService(captureSession: captureSession)
        self.captureSession = captureSession
        self.observationStore = ObservationStore()

        let mobileNet = MobileNet()
        let observationServiceQueue = DispatchQueue.makeQueue(for: ObservationService.self)
        self.observationService = ObservationService(model: mobileNet.model,
                                                     eventQueue: observationServiceQueue)
        self.captureSessionQueue = DispatchQueue.makeQueue(for: TakePhotoCoordinator.self)
        self.observationService.delegate = self
    }

    func start(animated: Bool) {
        let viewController = TakePhotoViewController(captureSession: captureSession,
                                                     delegate: self)
        self.navigationController.pushViewController(viewController, animated: animated)
        self.takePhotoView = viewController
    }

    private func askCaptureDevicePermission() {
        CaptureDevicePermissionService.requestIfNeeded(for: .video) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(_):
                strongSelf.setupCaptureDevice()
            case .failure(let error):
                // TODO: Daniel - check again error handling video
                // strongSelf.handleRequestFailure(using: error)
                // https://github.com/Workable/swift-error-handler
                print(error)
            }
        }
    }

    private func setupCaptureDevice() {
        do {
            try self.captureSessionService.setupCamera(for: Constants.Video.type,
                                                             position: Constants.Device.position,
                                                             devicetypes: Constants.Device.types,
                                                             sampleBufferDelegate: self.cameraFrameExtractService)
            self.takePhotoView?.addCameraView()
            self.captureSessionQueue.async { self.captureSession.startRunning() }
            self.cameraFrameExtractService.delegate = self
        } catch let error {
            // TODO: Daniel - check again error handling video
            print(error)
        }
    }
}

// MARK: TakePhotoViewControllerDelegate

extension TakePhotoCoordinator: TakePhotoViewControllerDelegate {

    func takePhotoViewControllerWillAppear(_ viewController: TakePhotoViewController) {
        switch self.captureSessionService.isCaptureSessionSetup {
        case true:
            self.captureSessionQueue.async { self.captureSession.startRunning() }
        case false:
            self.askCaptureDevicePermission()
        }
    }


    func takePhotoViewControllerDidRequestTooglingCameraPosition(_ viewController: TakePhotoViewController) {
        do {
            self.currentCameraPosition = self.currentCameraPosition == .back ? .front : .back
            try self.captureSessionService.updatePosition(for: Constants.Device.types, mediaType: Constants.Video.type, position: currentCameraPosition)
        } catch let error {
            print(error)
            // TODO: Daniel - check again error handling video
            // strongSelf.handleRequestFailure(using: error)
            // https://github.com/Workable/swift-error-handler
        }
    }

    func takePhotoViewControllerDidRequestTooglingTorchPosition(_ viewController: TakePhotoViewController) {
        self.captureSessionService.updateTorch()
    }

    func takePhotoViewControllerDidRequestPermission(_ viewController: TakePhotoViewController) {

    }

    func takePhotoViewControllerDidRequesShowingObservations(_ viewController: TakePhotoViewController) {
        self.captureSession.stopRunning()
        let observationsCoordinator = ObservationResultsCoordinator(navigationController: self.navigationController, observationStore: self.observationStore)
        observationsCoordinator.start(animated: true)
        self.childCoordinators.append(observationsCoordinator)
    }
}

// MARK: - CameraFrameExtractServiceDelegate

extension TakePhotoCoordinator: CameraFrameExtractServiceDelegate {
    func cameraFrameExtractService(_ cameraFrameExtractService: CameraFrameExtractService, didExtractImage image: UIImage) {
        do {
            try self.observationService.observeContent(of: image)
        } catch let error {
            // TODO: Daniel - check again error handling video
            print(error)
        }
    }
}

extension TakePhotoCoordinator: ObservationServiceDelegate {
    func observationService(_ observationService: ObservationService, foundObservation observation: Observation) {
        self.observationStore.add(observation)
    }
}
