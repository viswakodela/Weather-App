//
//  UIEdgeInset+Extension.swift
//  Weather App
//
//  Created by Viswa Kodela on 2021-02-26.
//

import UIKit

extension UIEdgeInsets {
    var inverted: Self {
        return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
    }
}
