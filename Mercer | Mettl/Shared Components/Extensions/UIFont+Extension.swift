//
//  Extensions-SwiftUI.swift
//   Mercer | Mettl
//
//  Created by m@k on 14/04/22.
//

import UIKit

// Color Setup section
extension UIColor {
    static let appBasecolor: UIColor = UIColor(named: "AppBasecolor") ?? UIColor()
}

// FontFamily Setups
enum CustomFontSize: CGFloat {
    case vvvsmall = 8
    case extraSmall = 10
    case verySmall = 11
    case small = 12
    case mediumSmall = 13
    case regular = 14
    case semimedium = 15
    case medium = 16
    case large = 18
    case xlarge = 20
    case xxlarge = 22
    case xxxlarge = 24
    case vixlarge = 26
    case vxllarge = 28
}

enum CustomFont: String {
    case bold = "Roboto-Bold"
    case thin = "Roboto-Thin"
    case light = "Roboto-Light"
    case black = "Roboto-Black"
    case medium = "Roboto-Medium"
    case regular = "Roboto-Regular"
}

extension UIFont {
    static func setFont(fontType: CustomFont,
                        fontSize: CustomFontSize) -> UIFont {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return  UIFont(name: fontType.rawValue, size: fontSize.rawValue + fontSize.rawValue) ?? UIFont() } else {
            return UIFont(name: fontType.rawValue, size: fontSize.rawValue) ?? UIFont()
        }
    }
}
