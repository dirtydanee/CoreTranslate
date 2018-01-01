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
    func startRunningCamera()
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
    private let cameraFrameExtractService: CameraFrameExtractService & AVCaptureVideoDataOutputSampleBufferDelegate
    private let imageRecognitionService: ImageRecognitionService
    private var takePhotoView: TakePhotoView?
    private var currentCameraPosition = Constants.Device.position

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []

        let captureSession = AVCaptureSession()
        self.cameraFrameExtractService = CameraFrameExtractService(captureSession: captureSession, delegate: nil)
        self.captureSession = captureSession

        let mobileNet = MobileNet()
        let imageRecognitionServiceQueue = DispatchQueue(label: "com.dirtylabs.coretranslate.imageRecognitionServiceQueue")
        self.imageRecognitionService = ImageRecognitionService(model: mobileNet.model, eventQueue: imageRecognitionServiceQueue)
    }

    func start(animated: Bool) {
        let captureSessionQueue = DispatchQueue(label: "com.dirtylabs.coretranslate.captureSessionQueue")
        let viewController = TakePhotoViewController(captureSession: captureSession,
                                                     captureSessionQueue: captureSessionQueue,
                                                     delegate: self)
        self.navigationController.pushViewController(viewController, animated: animated)
        self.takePhotoView = viewController
    }
}

// MARK: TakePhotoViewControllerDelegate

extension TakePhotoCoordinator: TakePhotoViewControllerDelegate {

    func takePhotoViewControllerDidRequestPermission(_ viewController: TakePhotoViewController) {
        CaptureDevicePermissionService.requestIfNeeded(for: .video) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(_):
                do {
                    try strongSelf.captureSession.setupCamera(for: Constants.Video.type,
                                                          position: Constants.Device.position,
                                                          devicetypes: Constants.Device.types,
                                                          sampleBufferDelegate: strongSelf.cameraFrameExtractService)
                    strongSelf.takePhotoView?.startRunningCamera()
                    strongSelf.cameraFrameExtractService.delegate = strongSelf
                } catch let error {
                    // TODO: Daniel - check again error handling video
                    print(error)
                }
            case .failure(let error):
                // TODO: Daniel - check again error handling video
                // strongSelf.handleRequestFailure(using: error)
                // https://github.com/Workable/swift-error-handler
                break
            }
        }
    }

    func takePhotoViewControllerDidRequestFlippingCameraPosition(_ viewController: TakePhotoViewController) {
        do {
            self.currentCameraPosition = self.currentCameraPosition == .back ? .front : .back
            try self.captureSession.updatePosition(for: Constants.Device.types, mediaType: Constants.Video.type, position: currentCameraPosition)
        } catch let error {
            print(error)
            // TODO: Daniel - check again error handling video
            // strongSelf.handleRequestFailure(using: error)
            // https://github.com/Workable/swift-error-handler
        }
    }
}

// MARK: - CameraFrameExtractServiceDelegate

extension TakePhotoCoordinator: CameraFrameExtractServiceDelegate {
    func cameraFrameExtractService(_ cameraFrameExtractService: CameraFrameExtractService, didExtractImage image: UIImage) {
        self.imageRecognitionService.recognizeContent(of: image)
    }
}
