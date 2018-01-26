//
//  SettingsTextFieldCell.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 22.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit
import StyledText

class SettingsTextFieldCell: UITableViewCell, RegisterableView {

    @IBOutlet private weak var titleLabel: StyledLabel!
    @IBOutlet private weak var textField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
