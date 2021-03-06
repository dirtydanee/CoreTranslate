//
//  LanguageCell.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 24.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit
import StyledText

final class LanguageCell: UITableViewCell, RegisterableView, TextStyleable {

    let titleLabels: [StyledLabel] = []
    let valueLabels: [StyledLabel] = []

    @IBOutlet private weak var languageLabel: StyledLabel!
    @IBOutlet private weak var flagLabel: StyledLabel!

    func configure(viewModel: LanguageViewModel) {
        self.languageLabel.text = viewModel.name
        self.flagLabel.text = viewModel.flag
    }
}
