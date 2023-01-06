//
//  UIViewController+Extensin.swift
//  Mercer | Mettl
//
//  Created by m@k on 17/05/22.
//

import Foundation
import UIKit
import Pendo

extension UIViewController {
    // MARK: - Status bar color setup.
    func setStatusBarColor(color: UIColor = UIColor.setColor(colorType: .darkBlueBG) ) {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let statusBarFrame = window?.windowScene?.statusBarManager?.statusBarFrame
            let statusBarView = UIView(frame: statusBarFrame!)
            self.view.addSubview(statusBarView)
            statusBarView.backgroundColor = color
        } else {
            // Below iOS13
            let statusBarFrame = UIApplication.shared.statusBarFrame
            let statusBarView = UIView(frame: statusBarFrame)
            self.view.addSubview(statusBarView)
            statusBarView.backgroundColor = color
        }
    }
    
    // MARK: - Pendo Analytics
    func startPendoSession(visitorid: String = "",
                           accountid: String = "",
                           visitordata: [String: Any] = ["": ""],
                           accountdata: [String: Any] = ["": ""]) {
        PendoManager.shared().startSession(
            visitorid,
            accountId: accountid,
            visitorData: visitordata,
            accountData: accountdata)
    }
    
    // MARK: - Alert Extension
    func showAlertController(title: String, message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Ok", style: .default) { _ in
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showQuitTestAlertController(title: String, message: String, router: NextSceneDismisser?) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.setMessageAlignment(.left)
        let notNow = UIAlertAction.init(title: AppConstant.quiteBackBtnTitle,
                                        style: .default) { _ in
        }
        let yes = UIAlertAction.init(title: AppConstant.quiteQuitBtnTitle, style: .destructive) { _ in
            DispatchQueue.main.async {
                UIAccessibility.requestGuidedAccessSession(enabled: false) { didSucceed in
                    router?.dismiss(controller: .landing)
                }
            }
        }
        alert.view.tintColor = UIColor(named: "DarkBlue")
        alert.addAction(yes)
        alert.addAction(notNow)
        self.present(alert, animated: true, completion: nil)
    }
    // Image converter function
    func convertImageToBase64String(img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    func convertBase64StringToImage(imageBase64String: String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
    
    func checkDeviceMirroring() -> Bool {
//        if UIScreen.screens.count < 2 {
//           return false
//        } else {
//           return true
//        }
        
        if UIScreen.main.isCaptured {
            return true
        }
        else {
            return false
        }
    }
}
