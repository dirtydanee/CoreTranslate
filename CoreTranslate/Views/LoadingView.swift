//
//  LoadingView.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 22.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

final class LoadingView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        let blurEffect = UIBlurEffect(style: .light)
        let visualView = UIVisualEffectView(effect: blurEffect)
        visualView.frame = frame
        visualView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.center = visualView.center
        activityIndicator.startAnimating()
        visualView.contentView.addSubview(activityIndicator)

        self.addSubview(visualView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
