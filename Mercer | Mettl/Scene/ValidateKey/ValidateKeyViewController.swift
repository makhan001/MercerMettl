//
//  ViewController.swift
//  Dev_Mercer_Mettl
//
//  Created by m@k on 18/05/22.
//
import UIKit
import SideMenu

class ValidateKeyViewController: UIViewController {
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lblErrorMsg: UILabel!
    @IBOutlet weak var lblProvideKey: UILabel!
    @IBOutlet weak var lblMercerAssessment: UILabel!
    
    @IBOutlet weak var btnValidate: UIButton!
    @IBOutlet weak var btnSideMenu: UIButton!
    
    @IBOutlet weak var TFInvitationKey: UITextField! // mak changes txtValidateKey user txt
    
    let viewModel = ValidateKeyViewModel(provider: OnboardingServiceProvider())
    
    weak var router: NextSceneDismisser?
    let url = "https://tests.mettl.xyz/v2/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

// MARK: - Instance Method
extension ValidateKeyViewController {
    private func setup() {
        self.viewModel.view = self
        
        //mak changes use self for the class properties and methods every where in the project and declare them as private if they are not required to used by other clas
        
        self.lblWelcome.font = UIFont.setFont(fontType: .light, fontSize: .large)
        lblMercerAssessment.font = UIFont.setFont(fontType: .regular, fontSize: .vxllarge)
        lblProvideKey.font = UIFont.setFont(fontType: .regular, fontSize: .small)
        btnValidate.titleLabel?.font =  UIFont.setFont(fontType: .medium, fontSize: .medium)
        lblErrorMsg.font = UIFont.setFont(fontType: .regular, fontSize: .small)
        
        TFInvitationKey.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        [ btnValidate, btnSideMenu ].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
    
    private func validateData() -> Bool {
        TFInvitationKey.borderWidth = 0.5
        TFInvitationKey.layer.cornerRadius = 5
        
        
        // mak changes do not force wrap user optional chain check below use this
        
        // before guard TFInvitationKey.text! == "1234" else {
        // guard let text = TFInvitationKey.text, text.count > 6 else {
        
        guard let text = TFInvitationKey.text, text != "" else {
            lblErrorMsg.text = AppConstant.emptyInvitationKey
            TFInvitationKey.borderColor = .red
            return false
        }
        
        guard let text = TFInvitationKey.text, text.count > 6 else {
            lblErrorMsg.text = AppConstant.incorrectInvitationKey
            TFInvitationKey.borderColor = .red
            return false
        }
        
        TFInvitationKey.borderColor = .gray
        lblErrorMsg.text = ""
        return true
    }
    
    private func startWebView() {
        print("navigate to web view")
        self.router?.push(scene: .webview)
    }
}

// MARK: - Observers
extension ValidateKeyViewController {
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.validateKey()
    }
}


// MARK: - Button Action
extension ValidateKeyViewController {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnValidate:
            if validateData() {
//                 router?.push(scene: .webview)
                self.viewModel.validate(key: TFInvitationKey.text ?? "")
            }
            
        case btnSideMenu:
            // mak changes use separate func when you are in switch case 2 line is good but it is more than it then use a separate private func as action for the button the way I didi for side menu action
            self.sideMenuAction()
        default:
            break
        }
    }
    
    private func sideMenuAction() {
        let menu = self.storyboard?.instantiateViewController(withIdentifier: "Left_menu") as! SideMenuNavigationController
        menu.menuWidth = self.view.frame.width - 10
        menu.presentationStyle = .menuSlideIn
        menu.leftSide = true
        present(menu, animated: true, completion: nil)
        print("btnSideMenu")
    }
    
    private func validateKey() {
        if validateData() {
            print("Yeah its done")
        }
    }
}

// MARK: - API Callbacks
extension ValidateKeyViewController: OnboardingViewRepresentable {
    func onAction(_ action: OnboardingAction) {
        switch action {
        case let .errorMessage(text), let .requireFields(text: text):
            print("error messsage ---> \(text)")
        case .validate:
            self.startWebView()
        default:
            break
        }
    }
}

