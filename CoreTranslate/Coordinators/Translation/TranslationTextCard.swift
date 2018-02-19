//
//  TranslationTextCard.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 20.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit
import StyledText

final class TranslationTextCard: UIView, NibLoadableView, TextStyleable {

    @IBOutlet private weak var fromLanguageLabel: StyledLabel!
    @IBOutlet private weak var fromWordLabel: StyledLabel!
    @IBOutlet private weak var toLanguageLabel: StyledLabel!
    @IBOutlet private weak var toWordLabel: StyledLabel!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var imageView: UIImageView!

    private(set) var titleLabels: [StyledLabel] = []
    private(set) var valueLabels: [StyledLabel] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabels = [self.fromLanguageLabel, self.toLanguageLabel]
        self.valueLabels = [self.toWordLabel, self.fromWordLabel]
        self.separatorView.backgroundColor = .ct_lightGrey
        self.backgroundColor = .ct_white
    }

    func present(translationViewPresentation: TranslationViewModel) {
        self.fromLanguageLabel.text = translationViewPresentation.from.language
        self.toLanguageLabel.text = translationViewPresentation.to.language
        self.fromWordLabel.text = translationViewPresentation.from.value
        self.toWordLabel.text = translationViewPresentation.to.value
    }
}
