//
//  TakePhotoCoordinator.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 10.12.17.
//  Copyright © 2017 Dirtylabs. All rights reserved.
//

import UIKit
import AVFoundation

final class ScanCoordinator: Coordinator {

    struct Constants {
        struct Video {
            static let type: AVMediaType = .video
        }

        struct Device {
            static let position: AVCaptureDevice.Position = .back
            static let types: [AVCaptureDevice.DeviceType] = [.builtInWideAngleCamera]
        }
    }

    var viewController: UIViewController? {
        return self.navigationController
    }

    let parent: Coordinator?
    private(set) var childCoordinators: [Coordinator]

    let languageStore: LanguageStore
    let navigationController: UINavigationController

    private let captureSession: AVCaptureSession
    private let captureSessionService: CaptureSessionService
    private let captureSessionQueue: DispatchQueue
    private let cameraFrameExtractService: CameraFrameExtractService & AVCaptureVideoDataOutputSampleBufferDelegate
    private let observationService: ObservationService
    private let observationStore: ObservationStore
    private var takePhotoViewController: ScanViewController?
    private var currentCameraPosition = Constants.Device.position

    init(navigationController: UINavigationController,
         languageStore: LanguageStore,
         parent: Coordinator?) {
        self.navigationController = navigationController
        self.languageStore = languageStore
        self.parent = parent
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
        self.captureSessionQueue = DispatchQueue.makeQueue(for: ScanCoordinator.self)
        self.observationService.delegate = self
    }

    func start(animated: Bool) {
        let viewController = ScanViewController(captureSession: captureSession,
                                                     delegate: self)
        self.navigationController.pushViewController(viewController, animated: animated)
        self.takePhotoViewController = viewController
    }

    func handle(event: Event) {
        //TODO: Handle event
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
            self.takePhotoViewController?.addCameraView()
            self.captureSessionQueue.async { self.captureSession.startRunning() }
            self.cameraFrameExtractService.delegate = self
        } catch let error {
            // TODO: Daniel - check again error handling video
            print(error)
        }
    }
}

// MARK: TakePhotoViewControllerDelegate

extension ScanCoordinator: ScanViewControllerDelegate {

    func scanViewControllerWillAppear(_ viewController: ScanViewController) {
        switch self.captureSessionService.isCaptureSessionSetup {
        case true:
            self.captureSessionQueue.async {
                self.captureSession.startRunning()
                viewController.removeBlurOverlay(animated: true)
            }
        case false:
            self.askCaptureDevicePermission()
        }
    }

    func scanViewControllerDidRequestTooglingCameraPosition(_ viewController: ScanViewController) {
        do {
            self.currentCameraPosition = self.currentCameraPosition == .back ? .front : .back
            try self.captureSessionService.updatePosition(for: Constants.Device.types,
                                                          mediaType: Constants.Video.type,
                                                          position: currentCameraPosition)
        } catch let error {
            print(error)
            // TODO: Daniel - check again error handling video
            // strongSelf.handleRequestFailure(using: error)
            // https://github.com/Workable/swift-error-handler
        }
    }

    func scanViewControllerDidRequestTooglingTorchPosition(_ viewController: ScanViewController) {
        self.captureSessionService.updateTorch()
    }

    func scanViewControllerDidRequesShowingObservations(_ viewController: ScanViewController) {
        self.captureSession.stopRunning()
        viewController.addBlurOverlay(withStyle: .regular)
        let observationsCoordinator = ObservationResultsCoordinator(navigationController: self.navigationController,
                                                                    observationStore: self.observationStore,
                                                                    languageStore: self.languageStore,
                                                                    parent: self)
        observationsCoordinator.start(animated: true)
        self.childCoordinators.append(observationsCoordinator)
    }

    func scanViewControllerDidPressTakePhoto(_ viewController: ScanViewController) {
        // TODO: Daniel - handle case when taking photo
    }
}

// MARK: - CameraFrameExtractServiceDelegate

extension ScanCoordinator: CameraFrameExtractServiceDelegate {
    func cameraFrameExtractService(_ cameraFrameExtractService: CameraFrameExtractService,
                                   didExtractImage image: UIImage) {
        do {
            // TODO: Reenable me to add observation
            // TODO: Hardcore memory pressure observed
            // try self.observationService.observeContent(of: image)
        } catch let error {
            // TODO: Daniel - check again error handling video
            print(error)
        }
    }
}

extension ScanCoordinator: ObservationServiceDelegate {
    func observationService(_ observationService: ObservationService, foundObservation observation: Observation) {
        self.observationStore.add(observation)
    }
}
