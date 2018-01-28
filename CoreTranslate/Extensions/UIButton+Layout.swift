//
//  UIButton+Layout.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 26.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

extension UIButton {

    func alignVertically(padding: CGFloat = 8.0) {
        let imageSize = self.imageView!.frame.size
        let titleSize = self.titleLabel!.frame.size
        let totalHeight = imageSize.height + titleSize.height + padding

        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: 0,
            bottom: 0,
            right: -titleSize.width
        )

        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom: -(totalHeight - titleSize.height),
            right: 0
        )
    }

}
