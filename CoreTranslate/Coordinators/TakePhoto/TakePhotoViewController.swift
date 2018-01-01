//
//  TakePhotoViewController.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 10.12.17.
//  Copyright © 2017 Dirtylabs. All rights reserved.
//

import UIKit
import AVFoundation

protocol TakePhotoViewControllerDelegate: class {
    func takePhotoViewControllerDidRequestPermission(_ viewController: TakePhotoViewController)
    func takePhotoViewControllerDidRequestFlippingCameraPosition(_ viewController: TakePhotoViewController)
}

final class TakePhotoViewController: UIViewController {

    let captureSession: AVCaptureSession
    let captureSessionQueue: DispatchQueue
    let previewLayer: AVCaptureVideoPreviewLayer
    let delegate: TakePhotoViewControllerDelegate?

    @IBOutlet private weak var cameraView: UIView!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init(captureSession: AVCaptureSession,
                  captureSessionQueue: DispatchQueue,
                  delegate: TakePhotoViewControllerDelegate?) {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.captureSession = captureSession
        self.delegate = delegate
        self.captureSessionQueue = captureSessionQueue
        super.init(nibName: "TakePhotoViewController", bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.delegate?.takePhotoViewControllerDidRequestPermission(self)
    }

    @IBAction func flipCamera(_ sender: UIButton) {
        self.delegate?.takePhotoViewControllerDidRequestFlippingCameraPosition(self)
    }
}

extension TakePhotoViewController: TakePhotoView {

    func startRunningCamera() {
        self.previewLayer.frame = self.cameraView.bounds
        self.cameraView.layer.addSublayer(self.previewLayer)
        self.captureSessionQueue.async {
            self.captureSession.startRunning()
        }
    }
}
