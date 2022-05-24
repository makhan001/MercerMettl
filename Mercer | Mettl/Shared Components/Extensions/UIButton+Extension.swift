//
//  UIButton+Extension.swift
//  Mercer | Mettl
//
//  Created by Dipak Agalcha on 23/05/22.
//

import Foundation
import UIKit

extension UIButton {
    func loadingIndicator(_ show: Bool) {
        let indicatorTag = 808404
        if show {
            isEnabled = false
            alpha = 0
            let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
            indicator.center = center
            indicator.tag = indicatorTag
            superview?.addSubview(indicator)
            indicator.startAnimating()
        } else {
            isEnabled = true
            alpha = 1.0
            if let indicator = superview?.viewWithTag(indicatorTag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
