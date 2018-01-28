//
//  ScanOverlayViewController.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 26.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit
import StyledText

final class ScanOverlayViewController: UIViewController {

    private var typedView: BlurOverlayView!
    private var startButton: StyledButton!
    private var handler: StartButtonHandler?
    typealias StartButtonHandler = () -> Void

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let typedView = BlurOverlayView(frame: UIScreen.main.bounds)
        self.view = typedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.setupStartButton()
    }

    func onRequestingStart(_ handler: @escaping StartButtonHandler) {
        self.handler = handler
    }

    private func setupStartButton() {
        let button = StyledButton(frame: .zero)
        button.normalTextStyle = ButtonStyle.largeBlackStyle
        button.setTitle("Start scanning!", for: .normal)
        button.setImage(#imageLiteral(resourceName: "ic_start"), for: .normal)
        button.sizeToFit()
        button.center = self.view.center
        button.alignVertically()
        button.addTarget(self, action: #selector(didPressStartButton(_:)), for: .touchUpInside)
        self.view.addSubview(button)
        self.startButton = button
    }

    @objc
    private func didPressStartButton(_ sender: UIButton) {
        self.handler?()
    }
}
