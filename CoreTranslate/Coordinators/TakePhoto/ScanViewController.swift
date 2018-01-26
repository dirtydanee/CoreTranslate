//
//  TakePhotoViewController.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 10.12.17.
//  Copyright © 2017 Dirtylabs. All rights reserved.
//

import UIKit
import AVFoundation

protocol ScanViewControllerDelegate: class {
    func scanViewControllerWillAppear(_ viewController: ScanViewController)
    func scanViewControllerDidRequestTooglingCameraPosition(_ viewController: ScanViewController)
    func scanViewControllerDidRequestTooglingTorchPosition(_ viewController: ScanViewController)
    func scanViewControllerDidRequesShowingObservations(_ viewController: ScanViewController)
    func scanViewControllerDidPressTakePhoto(_ viewController: ScanViewController)
}

final class ScanViewController: UIViewController {

    let captureSession: AVCaptureSession
    let previewLayer: AVCaptureVideoPreviewLayer
    weak var delegate: ScanViewControllerDelegate?

    @IBOutlet private weak var cameraView: UIView!
    @IBOutlet private weak var torchButton: UIButton!
    private var blurOverlayView: BlurOverlayView?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init(captureSession: AVCaptureSession,
                  delegate: ScanViewControllerDelegate?) {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.captureSession = captureSession
        self.delegate = delegate
        super.init(nibName: "ScanViewController", bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .ct_black
        self.cameraView.backgroundColor = .clear
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.delegate?.scanViewControllerWillAppear(self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.previewLayer.frame = CGRect(origin: .zero, size: self.cameraView.bounds.size)
    }

    @IBAction func toogleCamera(_ sender: UIButton) {
        self.delegate?.scanViewControllerDidRequestTooglingCameraPosition(self)
    }

    @IBAction func toogleTourch(_ sender: UIButton) {
        self.delegate?.scanViewControllerDidRequestTooglingTorchPosition(self)
    }

    @IBAction func showObservations(_ sender: UIButton) {
        self.delegate?.scanViewControllerDidRequesShowingObservations(self)
    }

    @IBAction func didPressTakePhoto(_ sender: UIButton) {
        clog(#function, priority: .debug)
        self.delegate?.scanViewControllerDidPressTakePhoto(self)
    }
}

extension ScanViewController {

    func addCameraView() {
        self.previewLayer.frame = CGRect(origin: .zero, size: self.cameraView.bounds.size)
        self.previewLayer.videoGravity = .resizeAspectFill
        self.cameraView.layer.addSublayer(self.previewLayer)
    }

    func addBlurOverlay(withStyle style: UIBlurEffectStyle) {
        let overlay = BlurOverlayView(frame: self.view.bounds)
        overlay.blurEffectStyle = style
        self.blurOverlayView = overlay
        self.view.addSubview(overlay)
    }

    func removeBlurOverlay(animated: Bool) {
        DispatchQueue.main.async {
            let duration: TimeInterval = animated ? 0.33 : 0
            UIView.animate(withDuration: duration, animations: {
                self.blurOverlayView?.alpha = 0
            }) { _ in
                self.blurOverlayView?.removeFromSuperview()
            }
        }
    }
}
