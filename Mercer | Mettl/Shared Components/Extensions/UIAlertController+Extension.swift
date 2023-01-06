//
//  UIAlertController+Extension.swift
//  Mercer | Mettl
//
//  Created by mohd-ali-khan on 05/12/22.
//

import Foundation
import UIKit

public extension UIAlertController {
    
    func setMessageAlignment(_ alignment : NSTextAlignment) {
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = alignment
        
        let messageText = NSMutableAttributedString(
            string: self.message ?? "",
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont.setFont(fontType: .regular, fontSize: .regular),
                NSAttributedString.Key.foregroundColor: UIColor.gray
            ]
        )
        self.setValue(messageText, forKey: "attributedMessage")
        
        let titleText = NSMutableAttributedString(
            string: self.title ?? "",
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont.setFont(fontType: .bold, fontSize: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.black
            ]
        )
        self.setValue(titleText, forKey: "attributedTitle")
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        for i in self.actions {
            let attributedText = NSAttributedString(string: i.title ?? "", attributes: [NSAttributedString.Key.font : UIFont.setFont(fontType: .regular, fontSize: .large)])

            guard let label = (i.value(forKey: "__representer") as AnyObject).value(forKey: "label") as? UILabel else { return }
            label.attributedText = attributedText
        }

    }
    
}
