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
    func takePhotoViewControllerWillAppear(_ viewController: TakePhotoViewController)
    func takePhotoViewControllerDidRequestTooglingCameraPosition(_ viewController: TakePhotoViewController)
    func takePhotoViewControllerDidRequestTooglingTorchPosition(_ viewController: TakePhotoViewController)
    func takePhotoViewControllerDidRequesShowingObservations(_ viewController: TakePhotoViewController)
}

final class TakePhotoViewController: UIViewController {

    let captureSession: AVCaptureSession
    let previewLayer: AVCaptureVideoPreviewLayer
    let delegate: TakePhotoViewControllerDelegate?

    @IBOutlet private weak var cameraView: UIView!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init(captureSession: AVCaptureSession,
                  delegate: TakePhotoViewControllerDelegate?) {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.captureSession = captureSession
        self.delegate = delegate
        super.init(nibName: "TakePhotoViewController", bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.delegate?.takePhotoViewControllerWillAppear(self)
    }

    @IBAction func toogleCamera(_ sender: UIButton) {
        self.delegate?.takePhotoViewControllerDidRequestTooglingCameraPosition(self)
    }

    @IBAction func toogleTourch(_ sender: UIButton) {
        self.delegate?.takePhotoViewControllerDidRequestTooglingTorchPosition(self)
    }

    @IBAction func showObservations(_ sender: UIButton) {
        self.delegate?.takePhotoViewControllerDidRequesShowingObservations(self)
    }
}

extension TakePhotoViewController: TakePhotoView {

    func addCameraView() {
        self.previewLayer.frame = self.cameraView.bounds
        self.cameraView.layer.addSublayer(self.previewLayer)
    }
}
