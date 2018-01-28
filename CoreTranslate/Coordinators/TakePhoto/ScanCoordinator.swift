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
    private var currentCameraPosition = Constants.Device.position

    private var scanViewController: ScanViewController?
    private var scanOverlayViewController: ScanOverlayViewController?
    private var photoDisplayViewController: PhotoDisplayViewController?

    init(navigationController: UINavigationController,
         languageStore: LanguageStore,
         parent: Coordinator?) {
        self.navigationController = navigationController
        self.languageStore = languageStore
        self.parent = parent
        self.childCoordinators = []

        let captureSession = AVCaptureSession()
        self.cameraFrameExtractService = CameraFrameExtractService(captureSession: captureSession)
        self.captureSessionService = CaptureSessionService(captureSession: captureSession)
        self.captureSession = captureSession
        self.observationStore = ObservationStore()

        let mobileNet = MobileNet()
        let observationServiceQueue = DispatchQueue.makeQueue(for: ObservationService.self)
        self.observationService = ObservationService(model: mobileNet.model,
                                                     eventQueue: observationServiceQueue)
        self.captureSessionQueue = DispatchQueue.makeQueue(for: ScanCoordinator.self)
    }

    func start(animated: Bool) {
        let scanViewController = ScanViewController(captureSession: captureSession,
                                                     delegate: self)
        self.addOverlay(toViewController: scanViewController)
        self.navigationController.pushViewController(scanViewController, animated: animated)
        self.scanViewController = scanViewController
    }

    func handle(event: Event) {
        //TODO: Handle event
    }
}

// MARK: Helper(s)

private extension ScanCoordinator {

    func runObservation(on image: UIImage) {
        do {
            try self.observationService.observeContent(of: image, completionHandler: { result in
                switch result {
                case .success(let observation):
                    self.observationStore.add(observation)
                case .failure(let error):
                    // TODO: Daniel - check again error handling video
                    clog("\(error)")
                }
            })
        } catch let error {
            // TODO: Daniel - check again error handling video
            clog("\(error)")
        }
    }

    func presentObservations() {
        let observationsCoordinator = ObservationResultsCoordinator(navigationController: self.navigationController,
                                                                    observationStore: self.observationStore,
                                                                    languageStore: self.languageStore,
                                                                    parent: self)
        observationsCoordinator.start(animated: true)
        self.childCoordinators.append(observationsCoordinator)
    }
}

// MARK: Overlay handling

private extension ScanCoordinator {

    func addOverlay(toViewController viewController: UIViewController) {
        viewController.loadViewIfNeeded()
        let overlayViewController = ScanOverlayViewController()
        viewController.addChildViewController(overlayViewController, frame: UIScreen.main.bounds)
        overlayViewController.onRequestingStart { [weak self, weak overlayViewController] in
            guard let strongSelf = self,
                let strongViewController = overlayViewController else { return }
            strongSelf.removeOverlay(strongViewController)
        }
        self.scanOverlayViewController = overlayViewController
    }

    func removeOverlay(_ viewController: ScanOverlayViewController, animated: Bool = true) {
        let duration = animated ? 0.33 : 0
        UIView.animate(withDuration: duration, animations: {
            viewController.view.frame.origin = CGPoint(x: 0, y: -viewController.view.bounds.height)
        }, completion: { _ in
            viewController.removeAsChildViewController()
            self.scanOverlayViewController = nil
            self.cameraFrameExtractService.startExtractingVideoFrames()
        })
    }
}

// MARK: Capture device handling

private extension ScanCoordinator {

    func askCaptureDevicePermission() {
        CaptureDevicePermissionService.requestIfNeeded(for: .video) { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    strongSelf.setupCaptureDevice()
                case .failure(let error):
                    // TODO: Daniel - check again error handling video
                    // strongSelf.handleRequestFailure(using: error)
                    // https://github.com/Workable/swift-error-handler
                    clog("\(error)")
                }
            }
        }
    }

    func setupCaptureDevice() {
        do {
            try self.captureSessionService.setupCamera(for: Constants.Video.type,
                                                       position: Constants.Device.position,
                                                       devicetypes: Constants.Device.types,
                                                       sampleBufferDelegate: self.cameraFrameExtractService)
            self.scanViewController?.addCameraView()
            self.captureSessionQueue.async { self.captureSession.startRunning() }
            self.cameraFrameExtractService.delegate = self
        } catch let error {
            // TODO: Daniel - check again error handling video
            clog("\(error)")
        }
    }
}

// MARK: Image display

private extension ScanCoordinator {

    func display(_ image: UIImage, animated: Bool = true) {
        guard let scanViewController = self.scanViewController else { return }

        let photoDisplayViewController = PhotoDisplayViewController()
        let childViewControllerHeight = scanViewController.view.bounds.height
            - (scanViewController.tabBarController?.tabBar.frame.height ?? 0)
        let childViewControllerFrame = CGRect(origin: scanViewController.view.bounds.origin,
                                              size: CGSize(width: scanViewController.view.bounds.width,
                                                           height: childViewControllerHeight))
        scanViewController.addChildViewController(photoDisplayViewController, frame: childViewControllerFrame)
        photoDisplayViewController.showCapturedImage(image,
                                                     animated: animated,
                                                     handler: self.processImageDispayActionDemand(_:))
        self.photoDisplayViewController = photoDisplayViewController
    }

    func processImageDispayActionDemand(_ demand: PhotoDisplayViewController.ActionDemand) {
        weak var weakSelf = self
        guard let strongSelf = weakSelf,
            let photoDisplayViewController = strongSelf.photoDisplayViewController else {
                return
        }

        switch demand {
        case .discard:
            photoDisplayViewController.removeAsChildViewController()
            self.captureSession.startRunning()
            self.cameraFrameExtractService.startExtractingVideoFrames()
        case .observe(let image):
            self.runObservation(on: image)
            self.presentObservations()
            photoDisplayViewController.removeAsChildViewController()
            self.scanViewController?.addBlurOverlay(withStyle: .regular)
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
            clog("\(error)")
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
        self.presentObservations()
    }

    func scanViewControllerDidPressTakePhoto(_ viewController: ScanViewController) {
        do {
            try self.captureSessionService.capturePhoto(handler: { result in

                // Stop extracting frames and invalidate all results so far
                self.cameraFrameExtractService.stopExtractingVideoFrames()
                self.observationStore.removeAll()

                switch result {
                case .failure(let error):
                    // TODO: Daniel - check again error handling video
                    clog("\(error)")
                case .success(let image):
                    self.captureSession.stopRunning()
                    self.display(image)
                }
            })
        } catch let error {
            // TODO: Daniel - check again error handling video
            clog("\(error)")
        }
    }
}

// MARK: - CameraFrameExtractServiceDelegate

extension ScanCoordinator: CameraFrameExtractServiceDelegate {
    func cameraFrameExtractService(_ cameraFrameExtractService: CameraFrameExtractService,
                                   didExtractImage image: UIImage) {
        self.runObservation(on: image)
    }
}
