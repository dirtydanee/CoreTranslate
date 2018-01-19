//
//  TranslationView.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 13.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit
import StyledText

struct TranslationViewStyle {
    let titleStyle: TextStyle
    let valueStyle: TextStyle
}

class TranslationView: UIView, NibLoadableView {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var fromLangugateTitle: StyledLabel!
    @IBOutlet private weak var fromLangugateValue: StyledLabel!
    @IBOutlet private weak var toLangugateTitle: StyledLabel!
    @IBOutlet private weak var toLangugateValue: StyledLabel!

    func setup(with style: TranslationViewStyle) {
        self.fromLangugateTitle.textStyle = style.titleStyle
        self.toLangugateTitle.textStyle = style.titleStyle
        self.fromLangugateValue.textStyle = style.valueStyle
        self.toLangugateValue.textStyle = style.valueStyle
    }

    func present(_ viewPresentation: TranslationViewPresentation) {
        self.fromLangugateTitle.text = viewPresentation.fromLanguage
        self.fromLangugateValue.text = viewPresentation.originalText
        self.toLangugateTitle.text = viewPresentation.toLanguage
        self.toLangugateValue.text = viewPresentation.translatedText
        self.imageView.image = viewPresentation.image
    }
}
