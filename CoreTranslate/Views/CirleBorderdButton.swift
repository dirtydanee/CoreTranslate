//
//  CirleBorderdButton.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 23.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

final class CirleBorderdButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        blurView.frame = self.bounds
        blurView.layer.cornerRadius = 0.5 * self.bounds.width
        blurView.clipsToBounds = true
        blurView.isUserInteractionEnabled = false
        self.addSubview(blurView)

        let size = CGSize(width: self.bounds.width * 0.7, height: self.bounds.height * 0.7)
        let viewFrame = CGRect(origin: .zero, size: size)
        let view = UIView(frame: viewFrame)
        view.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        view.backgroundColor = .white
        view.layer.cornerRadius = 0.5 * view.bounds.width
        view.isUserInteractionEnabled = false
        self.addSubview(view)
        self.layer.cornerRadius = 0.5 * self.bounds.width

        self.addTarget(self, action: #selector(didTouchDownButton(_:)), for: .touchDown)
        self.addTarget(self, action: #selector(didTouchCancelButton(_:)), for: .touchCancel)
        self.addTarget(self, action: #selector(didTouchUpOutsideButton(_:)), for: .touchUpOutside)
        self.addTarget(self, action: #selector(didTouchUpInsideButton(_:)), for: .touchUpInside)
    }

    @objc
    private func didTouchDownButton(_ sender: UIButton) {
        self.subviews.forEach { $0.alpha = 0.6 }
    }

    @objc
    private func didTouchCancelButton(_ sender: UIButton) {
        self.subviews.forEach { $0.alpha = 1 }
    }

    @objc
    private func didTouchUpInsideButton(_ sender: UIButton) {
        self.subviews.forEach { $0.alpha = 1 }
    }

    @objc
    private func didTouchUpOutsideButton(_ sender: UIButton) {
        self.subviews.forEach { $0.alpha = 1 }
    }
}
