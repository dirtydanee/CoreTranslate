//
//  BlurOverlayView.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 23.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

final class BlurOverlayView: UIView {

    var blurEffectStyle: UIBlurEffectStyle = .light {
        didSet {
            self.setupBlurView(style: self.blurEffectStyle)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupBlurView(style: self.blurEffectStyle)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupBlurView(style: self.blurEffectStyle)
    }

    private func setupBlurView(style: UIBlurEffectStyle) {
        // Remove all current subviews, if any
        self.subviews.forEach { $0.removeFromSuperview() }

        // Add blur effect with correct style
        let blurEffect = UIBlurEffect(style: style)
        let visualView = UIVisualEffectView(effect: blurEffect)
        visualView.frame = self.bounds
        visualView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(visualView)
    }
}
