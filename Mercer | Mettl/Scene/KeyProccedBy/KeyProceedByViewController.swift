//
//  KeyProceedByViewController.swift
//  Dev_Mercer_Mettl
//
//  Created by mohd-ali-khan on 15/11/22.
//

import UIKit
import SideMenu

class KeyProceedByViewController: UIViewController {
    @IBOutlet weak var lblWhatLikeToHeading: UILabel!
    @IBOutlet weak var lblGiveAssesment: UILabel!
    @IBOutlet weak var lblMobileFriendly: UILabel!
    @IBOutlet weak var lblQRCodeScanning: UILabel!
    @IBOutlet weak var lblCandidatecanlink: UILabel!
    @IBOutlet weak var btnGetStarted: UIButton!
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var imgSidemenuBar: UIImageView!
    @IBOutlet weak var btnScanQRCode: UIButton!
    weak var router: NextSceneDismisser?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}
// MARK: - Instance Method
extension KeyProceedByViewController {
    private func setup() {
        self.configureFonts()
        self.configureButton()
    }
    
    private func configureFonts() {
        self.lblWhatLikeToHeading.font = UIFont.setFont(fontType: .regular, fontSize: .vxllarge)
        self.lblGiveAssesment.font = UIFont.setFont(fontType: .regular, fontSize: .xlarge)
        self.lblMobileFriendly.font = UIFont.setFont(fontType: .medium, fontSize: .small)
        self.lblQRCodeScanning.font = UIFont.setFont(fontType: .regular, fontSize: .xlarge)
        self.lblCandidatecanlink.font = UIFont.setFont(fontType: .medium, fontSize: .small)
        
    }
    private func configureButton() {
        self.btnGetStarted.titleLabel?.font = UIFont.setFont(fontType: .regular, fontSize: .regular)
        self.btnScanQRCode.titleLabel?.font = UIFont.setFont(fontType: .regular, fontSize: .regular)
        self.imgSidemenuBar.image = UIImage.fontAwesomeIcon(name: FontAwesome.bars,
                                                            style: .solid,
                                                            textColor: UIColor.white,
                                                            size: CGSize(width: 30, height: 30))
        [ btnSideMenu, btnGetStarted, btnScanQRCode].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
}

// MARK: - Button Action
extension KeyProceedByViewController {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnGetStarted:
            self.btnGetStartedAction()
        case btnScanQRCode:
            self.btnScanQRCodeAction()
        case btnSideMenu:
            self.sideMenuAction()
        default:
            break
        }
    }
   
    private func sideMenuAction() {
        // swiftlint:disable line_length
       
        guard let menu = self.storyboard?.instantiateViewController(withIdentifier: "Left_menu") as? SideMenuNavigationController
        else { return }
        menu.menuWidth = self.view.frame.width
        menu.leftSide = true
        menu.presentationStyle = .viewSlideOutMenuPartialIn
        guard let finalDestination = menu.viewControllers.first as? SideMenuViewController else {
               return
           }
        finalDestination.delegate = self
        present(menu, animated: true, completion: nil)
    }
    
    private func btnScanQRCodeAction() {
        router?.push(scene: .scanner)
    }
    
    private func btnGetStartedAction() {
        router?.push(scene: .validate)
    }
}

// MARK: - DelegateCallback Action
extension KeyProceedByViewController: abboutUsTappedDelegate {
    func aboutUsClicked() {
        DispatchQueue.main.async {
            self.router?.dismiss(controller: .landing)
        }
    }
}
