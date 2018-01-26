//
//  Styles.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 19.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit
import StyledText

extension UIColor {
    static let ct_white = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
    static let ct_lightGrey = UIColor(red:0.81, green:0.80, blue:0.84, alpha:1.0)
    static let ct_mediumGrey = UIColor(red:0.63, green:0.62, blue:0.69, alpha:1.0)
    static let ct_darkGrey = UIColor(red:0.54, green:0.51, blue:0.55, alpha:1.0)
    static let ct_black = UIColor(red:0.36, green:0.35, blue:0.38, alpha:1.0)
    static let ct_brown = UIColor(red:0.84, green:0.79, blue:0.74, alpha:1.0)
}

struct TextStyles {
    struct Header {
        static let titleStyle = TextStyle(font: UIFont.boldSystemFont(ofSize: 12), color: .ct_mediumGrey)
        static let valueStyle = TextStyle(font: UIFont.systemFont(ofSize: 16), color: .ct_black)
    }

    struct Cell {
        static let titleStyle = TextStyle(font: UIFont.boldSystemFont(ofSize: 12), color: .ct_mediumGrey)
        static let valueStyle = TextStyle(font: UIFont.systemFont(ofSize: 16), color: .ct_black)
    }
}

struct ViewStyle {
    let titleStyle: TextStyle
    let valueStyle: TextStyle

    static let headersStyle = ViewStyle(titleStyle: TextStyles.Header.titleStyle,
                                        valueStyle: TextStyles.Header.valueStyle)

    static let cellsStyle = ViewStyle(titleStyle: TextStyles.Cell.titleStyle,
                                      valueStyle: TextStyles.Cell.valueStyle)
}

struct ButtonStyle {
    static let normalStyle: TextStyle = TextStyle(font: UIFont.systemFont(ofSize: 16), color: .ct_black)
    static let selectedStyle: TextStyle = TextStyle(font: UIFont.systemFont(ofSize: 16), color: .ct_lightGrey)
}

protocol TextStyleable {
    var titleLabels: [StyledLabel] { get }
    var valueLabels: [StyledLabel] { get }

    func apply(style: ViewStyle)
}

extension TextStyleable {
    func apply(style: ViewStyle) {
        self.titleLabels.forEach { $0.textStyle = style.titleStyle }
        self.valueLabels.forEach { $0.textStyle = style.valueStyle }
    }
}
