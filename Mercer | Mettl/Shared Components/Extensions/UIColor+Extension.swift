//
//  UIColor+Extension.swift
//  Mercer | Mettl
//
//  Created by m@k on 10/03/22.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha:CGFloat = 1.0) {
        var hexInt: Int32 = 0
        let scanner = Scanner(string: hex)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanInt32(&hexInt)
        let red = CGFloat((hexInt & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexInt & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexInt & 0xff) >> 0) / 255.0
        let alpha = alpha
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
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
}
