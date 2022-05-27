//
//  UIColor+Extension.swift
//  Mercer | Mettl
//
//  Created by m@k on 10/03/22.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    func isEqualTo(_ color: UIColor) -> Bool {
        var red1: CGFloat = 0, green1: CGFloat = 0, blue1: CGFloat = 0, alpha1: CGFloat = 0
        getRed(&red1, green:&green1, blue:&blue1, alpha:&alpha1)
        
        var red2: CGFloat = 0, green2: CGFloat = 0, blue2: CGFloat = 0, alpha2: CGFloat = 0
        color.getRed(&red2, green:&green2, blue:&blue2, alpha:&alpha2)
        
        return red1 == red2 && green1 == green2 && blue1 == blue2 && alpha1 == alpha2
    }
    func colorFromCode(_ code: Int) -> UIColor {
        
        let red = CGFloat(((code & 0xFF0000) >> 16)) / 255
        let green = CGFloat(((code & 0xFF00) >> 8)) / 255
        let blue = CGFloat((code & 0xFF)) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    static var randomColor: UIColor {
        return UIColor(red: .random(in: 0...2), green: .random(in: 0...2), blue: .random(in: 0...2), alpha: 1.0)
    }
    
    //MARK: - Color Setups
    enum colorPalette : String {
        case quill = "Quill"
        case skyDark = "SkyDark"
        case darkBlue = "DarkBlue"
        case darkBlueBG = "DarkBlueBG"
        case primeryRed = "PrimeryRed"
        case quillLight = "QuillLight"
        case primaryBlue = "PrimaryBlue"
        case quillLighter = "QuillLighter"
        case quillLightest = "quillLightest"
        case primaryBlueDark = "PrimaryBlueDark"
    }
    
    static func setColor(colorType: colorPalette) -> UIColor {
        return UIColor(named: colorType.rawValue) ?? UIColor()
    }
}
