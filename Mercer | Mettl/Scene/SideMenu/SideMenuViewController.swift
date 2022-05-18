//
//  ViewController.swift
//  Dev_Mercer_Mettl
//
//  Created by m@k on 18/05/22.
//

import UIKit
import SafariServices

class SideMenuViewController: UIViewController {
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnHelp: UIButton!
    @IBOutlet weak var lblHelp: UILabel!
    @IBOutlet weak var btnAboutUs: UIButton!
    @IBOutlet weak var lblAboutUs: UILabel!
    @IBOutlet weak var lblNeedHelp: UILabel!
    @IBOutlet weak var lblPowerdBy: UILabel!
    @IBOutlet weak var lblCopyRights: UILabel!
    @IBOutlet weak var btnContactNumber: UIButton!
    @IBOutlet weak var lblContactNumber: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Instance Method
extension SideMenuViewController {
    private func setup() {
        lblPowerdBy.font = UIFont.setFont(fontType: .regular, fontSize: .small)
        lblCopyRights.font = UIFont.setFont(fontType: .regular, fontSize: .small)
        lblNeedHelp.font = UIFont.setFont(fontType: .medium, fontSize: .small)
        lblHelp.font = UIFont.setFont(fontType: .regular, fontSize: .small)
        lblAboutUs.font = UIFont.setFont(fontType: .regular, fontSize: .small)
        lblContactNumber.font = UIFont.setFont(fontType: .regular, fontSize: .small)
        
        [ btnBack, btnHelp, btnAboutUs, btnContactNumber].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
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
                callNumber()
        default:
            break
        }
        
        func OpenSafari(Url:String){
            if let url = URL(string: Url) {
                let safariViewController = SFSafariViewController(url: url)
                self.present(safariViewController, animated: true)
            }
        }
        
        func callNumber() {
            UIApplication.shared.open(NSURL(string: "tel://555-123-1234")! as URL)
        }
    }
}
