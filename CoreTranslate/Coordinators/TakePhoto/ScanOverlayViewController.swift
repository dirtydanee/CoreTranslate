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

    override func loadView() {
        let typedView = BlurOverlayView(frame: UIScreen.main.bounds)
        self.view = typedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupStartButton()
    }

    func setupStartButton() {
        let button = StyledButton(frame: CGRect(origin: .zero,
                                                size: CGSize(width: 54, height: 54)))
        button.center = self.view.center
        button.setTitle("Start scanning!", for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "ic_start"), for: .normal)
        button.addTarget(self, action: #selector(didPressStartButton(_:)), for: .touchUpInside)
        self.view.addSubview(button)
        self.startButton = button
    }

    @objc
    private func didPressStartButton(_ sender: UIButton) {

    }
}
