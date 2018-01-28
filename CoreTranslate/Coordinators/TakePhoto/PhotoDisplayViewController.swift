//
//  PhotoDisplayViewController.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 28.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit
import StyledText

final class PhotoDisplayViewController: UIViewController {

    enum ActionDemand {
        case discard
        case observe(UIImage)
    }

    typealias ImageDisplayHandler = (PhotoDisplayViewController.ActionDemand) -> Swift.Void

    private var imageView: UIImageView!
    private var repeatButton: StyledButton!
    private var handler: ImageDisplayHandler?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupImageView()
        self.setupRepeatButton()
        self.view.backgroundColor = .clear
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let repeatButton = self.repeatButton {
            let x = self.view.center.x - (repeatButton.frame.width / 2)
            let y = self.view.frame.height - repeatButton.frame.height - 16
            repeatButton.frame.origin = CGPoint(x: x, y: y)
        }
    }

    func showCapturedImage(_ image: UIImage, animated: Bool, handler: @escaping ImageDisplayHandler) {
        self.handler = handler
        let duration: TimeInterval = animated ? 0.33 : 0
        let portraitImage = image.rotate(byDegree: 90)
        self.imageView.image = portraitImage
        UIView.animate(withDuration: duration, animations: {
            self.imageView.alpha = 1
        }, completion: { _ in

        })
    }
}

// MARK: - Setup

private extension PhotoDisplayViewController {

    func setupImageView() {
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.contentMode = .scaleToFill
        imageView.alpha = 0
        self.view.addSubview(imageView)
        self.imageView = imageView
    }

    func setupRepeatButton() {
        let button = StyledButton(frame: .zero)
        button.setTitle(LocalizedString("General_Repeat"), for: .normal)
        button.normalTextStyle = ButtonStyle.largeWhiteStyle
        button.addTarget(self, action: #selector(didTapRepeat(_:)), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "ic_repeat"), for: .normal)
        button.sizeToFit()
        button.alignVertically()
        self.view.addSubview(button)
        self.repeatButton = button
    }

    @objc
    func didTapRepeat(_ sender: UIButton) {
        // TODO: Add animation upon presenting this guy
        // TODO: Add show observations button
        self.handler?(.discard)
    }
}
