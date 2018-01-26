//
//  LanguageSelectorView.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 24.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit
import StyledText

protocol LanguageSelectorHeaderViewDelegate: class {
    func languageSelectorView(_ languageSelectorView: LanguageSelectorHeaderView,
                              didSelectLanguageAtPosition position: LanguageSelectorHeaderView.Position)
}

final class LanguageSelectorHeaderView: UIView, NibLoadableView {

    @IBOutlet private weak var fromLanguageButton: StyledButton!
    @IBOutlet private weak var toLanguageButton: StyledButton!
    @IBOutlet private weak var dividerImageView: UIImageView!

    enum Position {
        case from
        case to
    }

    weak var delegate: LanguageSelectorHeaderViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        [self.fromLanguageButton, self.toLanguageButton].forEach {
            $0?.normalTextStyle = ButtonStyle.normalStyle
            $0?.highlightedTextStyle = ButtonStyle.selectedStyle
        }
    }

    func setTitle(_ text: String, atPosition position: LanguageSelectorHeaderView.Position) {
        let button: StyledButton
        switch position {
        case .from:
            button = fromLanguageButton
        case .to:
            button = toLanguageButton
        }
        button.setTitle(text, for: .normal)
    }

    @IBAction func didTapFromLanguageButton(_ sender: UIButton) {
        self.delegate?.languageSelectorView(self, didSelectLanguageAtPosition: .from)
    }

    @IBAction func didTapToLanguageButton(_ sender: UIButton) {
        self.delegate?.languageSelectorView(self, didSelectLanguageAtPosition: .to)
    }

}
