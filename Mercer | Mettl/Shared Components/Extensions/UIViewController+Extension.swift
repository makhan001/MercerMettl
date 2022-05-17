//
//  UIViewController+Extensin.swift
//  Mercer | Mettl
//
//  Created by m@k on 17/05/22.
//

import Foundation
import UIKit

extension UIViewController {
    func setStatusBarColor(color: UIColor = UIColor(named: "DarkBlueBG") ?? .black) {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let statusBarFrame = window?.windowScene?.statusBarManager?.statusBarFrame
            let statusBarView = UIView(frame: statusBarFrame!)
            self.view.addSubview(statusBarView)
            statusBarView.backgroundColor = color
        } else {
            //Below iOS13
            let statusBarFrame = UIApplication.shared.statusBarFrame
            let statusBarView = UIView(frame: statusBarFrame)
            self.view.addSubview(statusBarView)
            statusBarView.backgroundColor = color
        }
    }
}
