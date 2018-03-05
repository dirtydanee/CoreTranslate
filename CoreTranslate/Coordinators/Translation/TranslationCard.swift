//
//  TranslationCard.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 19.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit
import StyledText

final class TranslationCard: UICollectionViewCell, RegisterableView, TextStyleable {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var confidanceLabel: StyledLabel!
    @IBOutlet private weak var confidanceValueLabel: StyledLabel!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var textCardContainerView: UIView!

    private var translationTextCard: TranslationTextCard?
    private(set) var titleLabels: [StyledLabel] = []
    private(set) var valueLabels: [StyledLabel] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .ct_white
        self.titleLabels.append(self.confidanceLabel)
        self.valueLabels.append(self.confidanceValueLabel)
        self.confidanceLabel.text = LocalizedString("General_Confidance")
        self.separatorView.backgroundColor = .ct_lightGrey
        self.layer.cornerRadius = 8
        self.clipsToBounds = true

        let translationTextCard = TranslationTextCard.loadFromNib()
        translationTextCard.frame = self.textCardContainerView.bounds
        translationTextCard.apply(style: ViewStyle.cellsStyle)
        self.textCardContainerView.addSubview(translationTextCard)
        self.translationTextCard = translationTextCard

    }

    func configure(with viewModel: TranslatedObservationViewModel) {
        self.imageView.image = viewModel.image
        self.confidanceValueLabel.text = viewModel.confidance
        self.translationTextCard?.present(translationViewPresentation: viewModel.translationViewModel)
    }
}
