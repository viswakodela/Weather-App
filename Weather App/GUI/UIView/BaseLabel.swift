//
//  BaseLabel.swift
//  Weather App
//
//  Created by Viswa Kodela on 2021-02-26.
//

import UIKit

class BaseLabel: UILabel, FontUpdatable {

    override func awakeFromNib() {
        super.awakeFromNib()
        defaultSetup()
    }

    override func drawText(in rect: CGRect) {
        if let contentInset = contentInset {
            super.drawText(in: rect.inset(by: contentInset))
        } else {
            super.drawText(in: rect)
        }
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        guard let contentInset = contentInset else {
            return super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        }
        let insetRect = bounds.inset(by: contentInset)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        return textRect.inset(by: contentInset.inverted)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBInspectable
    var localizedTextKey: String! {
        didSet {
            self.text = localizedTextKey
        }
    }

    @IBInspectable
    var shouldUseDefaultTextColor: Bool = true

    // MARK: FontUpdatable
    @IBInspectable
    var fontWeightString: String = "" {
        didSet {
            updateFont()
        }
    }

    var contentInset: UIEdgeInsets? = nil {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    private(set) var fontTextStyle: UIFont.TextStyle?

    func didUpdateFont(_ font: UIFont) {
        self.font = font
    }

    func defaultSetup() {

        if shouldUseDefaultTextColor {
            self.textColor = .primaryTextColor
        }
        updateFont()
        self.adjustsFontForContentSizeCategory = true
        self.layer.masksToBounds = true
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        traitCollectionDidChange(previous: previousTraitCollection, current: traitCollection)
    }
}


class LargeTitleLabel: BaseLabel {
    override var fontTextStyle: UIFont.TextStyle? {
        return .largeTitle
    }
}


class Title1Label: BaseLabel {
    override var fontTextStyle: UIFont.TextStyle? {
        return .title1
    }
}


class Title2Label: BaseLabel {
    override var fontTextStyle: UIFont.TextStyle? {
        return .title2
    }
}


class Title3Label: BaseLabel {
    override var fontTextStyle: UIFont.TextStyle? {
        return .title3
    }
}


class HeadlineLabel: BaseLabel {
    override var fontTextStyle: UIFont.TextStyle? {
        return .headline
    }
}


class BodyLabel: BaseLabel {
    override var fontTextStyle: UIFont.TextStyle? {
        return .body
    }
}


class CalloutLabel: BaseLabel {
    override var fontTextStyle: UIFont.TextStyle? {
        return .callout
    }
}


class SubheadlineLabel: BaseLabel {
    override var fontTextStyle: UIFont.TextStyle? {
        return .subheadline
    }
}


class FootnoteLabel: BaseLabel {
    override var fontTextStyle: UIFont.TextStyle? {
        return .footnote
    }
}


class Caption1Label: BaseLabel {
    override var fontTextStyle: UIFont.TextStyle? {
        return .caption1
    }
}


class Caption2Label: BaseLabel {
    override var fontTextStyle: UIFont.TextStyle? {
        return .caption2
    }
}
