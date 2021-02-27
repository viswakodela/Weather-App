//
//  FontUpdatable.swift
//  Weather App
//
//  Created by Viswa Kodela on 2021-02-26.
//

import UIKit

protocol FontUpdatable: class {
    var fontWeightString: String { get set }
    var fontTextStyle: UIFont.TextStyle? { get }
    var attributedText: NSAttributedString? { get set }
    func didUpdateFont(_ font: UIFont)
    func updateFont()
    func setFontWeight(_ weight: UIFont.Weight)
    func traitCollectionDidChange(previous: UITraitCollection?, current: UITraitCollection)
}

extension FontUpdatable {

    func updateFont() {
        if let style = fontTextStyle {
            if let fontWeight = UIFont.Weight(string: fontWeightString) {
                didUpdateFont(.preferredFont(for: style, weight: fontWeight))
            } else {
                didUpdateFont(.preferredFont(forTextStyle: style))
            }
        }
    }

    func setFontWeight(_ weight: UIFont.Weight) {
        fontWeightString = weight.string
    }

    func traitCollectionDidChange(previous: UITraitCollection?, current: UITraitCollection) {
        if previous?.preferredContentSizeCategory != current.preferredContentSizeCategory {
            updateFont()
        }
    }
}
