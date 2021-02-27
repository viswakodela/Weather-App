//
//  UIFont+Extension.swift
//  Weather App
//
//  Created by Viswa Kodela on 2021-02-26.
//

import UIKit

extension UIFont.Weight {

    init?(string: String) {
        switch string {
        case "ultraLight":
            self = .ultraLight
        case "thin":
            self = .thin
        case "light":
            self = .light
        case "regular":
            self = .regular
        case "medium":
            self = .medium
        case "semibold":
            self = .semibold
        case "bold":
            self = .bold
        case "heavy":
            self = .heavy
        case "black":
            self = .black
        default:
            return nil
        }
    }

    var string: String {
        switch self {
        case .ultraLight:
            return "ultraLight"
        case .thin:
            return "thin"
        case .light:
            return "light"
        case .regular:
            return "regular"
        case .medium:
            return "medium"
        case .semibold:
            return "semibold"
        case .bold:
            return "bold"
        case .heavy:
            return "heavy"
        case .black:
            return "black"
        default:
            return ""
        }
    }
}

extension UIFont {
    static func preferredFont(for style: TextStyle, weight: Weight, size: CGFloat? = nil) -> UIFont {
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: size ?? desc.pointSize, weight: weight)
        return font
    }
}
