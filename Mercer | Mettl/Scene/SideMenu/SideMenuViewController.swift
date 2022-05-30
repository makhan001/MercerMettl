//
//  ViewController.swift
//  Dev_Mercer_Mettl
//
//  Created by m@k on 18/05/22.
//

import UIKit
import SafariServices

class SideMenuViewController: UIViewController {
    @IBOutlet weak var lblHelp: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnHelp: UIButton!
    @IBOutlet weak var lblAboutUs: UILabel!
    @IBOutlet weak var btnAboutUs: UIButton!
    @IBOutlet weak var lblNeedHelp: UILabel!
    @IBOutlet weak var lblContactOn: UILabel!
    @IBOutlet weak var lblPowerdBy: UILabel!
    @IBOutlet weak var lblCopyRights: UILabel!
    @IBOutlet weak var imgLeftArrow: UIImageView!
    @IBOutlet weak var lblContactNumber: UILabel!
    @IBOutlet weak var btnContactNumber: UIButton!
    @IBOutlet weak var lblUSContactNumber: UILabel!
    @IBOutlet weak var btnUSContactNumber: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Instance Method
extension SideMenuViewController {
    private func setup() {
        configureFonts()
        startPendoSession(visitorid: PendoConfiguration.visitorId)
        [ btnBack, btnHelp, btnAboutUs, btnContactNumber, btnUSContactNumber].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
    
    private func configureFonts() {
        lblPowerdBy.font = UIFont.setFont(fontType: .regular, fontSize: .small)
        lblCopyRights.font = UIFont.setFont(fontType: .regular, fontSize: .small)
        lblNeedHelp.font = UIFont.setFont(fontType: .medium, fontSize: .small)
        lblContactOn.font = UIFont.setFont(fontType: .medium, fontSize: .small)
        lblHelp.font = UIFont.setFont(fontType: .regular, fontSize: .small)
        lblAboutUs.font = UIFont.setFont(fontType: .regular, fontSize: .small)
        lblContactNumber.font = UIFont.setFont(fontType: .regular, fontSize: .small)
        lblUSContactNumber.font = UIFont.setFont(fontType: .regular, fontSize: .small)
        imgLeftArrow.image = UIImage.fontAwesomeIcon(name:FontAwesome.angleDoubleLeft, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
    }
}

// MARK: - Button Action
extension SideMenuViewController {
    
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnBack:
            dismiss(animated: true, completion: nil)
        case btnHelp:
            OpenSafari(Url: AppConstant.helpUrl)
        case btnAboutUs:
            OpenSafari(Url: AppConstant.aboutUsUrl )
        case btnContactNumber:
            callNumber(phoneNumber: lblContactNumber.text ?? "")
        case btnUSContactNumber:
            callNumber(phoneNumber: lblUSContactNumber.text ?? "")
        default:
            break
        }
        
        func OpenSafari(Url:String){
            if let url = URL(string: Url) {
                let safariViewController = SFSafariViewController(url: url)
                self.present(safariViewController, animated: true)
            }
        }
        
        func callNumber(phoneNumber:String) {
            UIApplication.shared.open(NSURL(string: "tel://\(phoneNumber)")! as URL)
        }
    }
}
