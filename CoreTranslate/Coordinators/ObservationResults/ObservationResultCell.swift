//
//  ObservationResultCell.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 06.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

class ObservationResultCell: UITableViewCell, RegisterableView {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var confidence: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        self.name.text = nil
        self.confidence.text = nil
    }

    func configure(with viewPresentation: ObservationViewPresentation) {
        self.name.text = viewPresentation.name
        self.confidence.text = viewPresentation.confidence
    }
}
