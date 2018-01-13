//
//  ObservationResultCell.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 06.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

class ObservationResultCell: UITableViewCell, RegisterableView {

    @IBOutlet weak var resultTitle: UILabel!
    @IBOutlet weak var resultValue: UILabel!
    @IBOutlet weak var confidanceTitle: UILabel!
    @IBOutlet weak var confidenceValue: UILabel!
    @IBOutlet weak var resultImageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        self.resultTitle.text = nil
        self.resultValue.text = nil
        self.confidanceTitle.text = nil
        self.confidenceValue.text = nil
        self.resultImageView.image = nil
    }

    func configure(with viewPresentation: ObservationViewPresentation) {
        self.resultTitle.text = viewPresentation.resultTitle
        self.resultValue.text = viewPresentation.resultValue

        self.confidanceTitle.text = viewPresentation.confidenceTitle
        self.confidenceValue.text = viewPresentation.confidenceValue

        self.resultImageView.image = viewPresentation.image
    }
}
