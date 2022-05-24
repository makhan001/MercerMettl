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
    @IBOutlet weak var btnProceed: UIButton!
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var txtValidateKey: UITextField!
    
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
        txtValidateKey.text = "369flx4jcw"
        self.lblWelcome.font = UIFont.setFont(fontType: .light, fontSize: .large)
        lblMercerAssessment.font = UIFont.setFont(fontType: .regular, fontSize: .vxllarge)
        lblProvideKey.font = UIFont.setFont(fontType: .regular, fontSize: .small)
        btnValidate.titleLabel?.font =  UIFont.setFont(fontType: .regular, fontSize: .small)
        btnProceed.titleLabel?.font =  UIFont.setFont(fontType: .medium, fontSize: .medium)
        lblErrorMsg.font = UIFont.setFont(fontType: .regular, fontSize: .small)
        txtValidateKey.font = UIFont.setFont(fontType: .regular, fontSize: .small)

        txtValidateKey.delegate = self
        txtValidateKey.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        [ btnValidate, btnSideMenu, btnProceed].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
    
    private func validateData() -> Bool {
        txtValidateKey.borderWidth = 0.5
        txtValidateKey.layer.cornerRadius = 5
        guard let text = txtValidateKey.text, text != "" else {
            lblErrorMsg.text = AppConstant.emptyInvitationKey
            txtValidateKey.borderColor = .red
            return false
        }
        
        guard let text = txtValidateKey.text, text.count > 6 else {
            lblErrorMsg.text = AppConstant.incorrectInvitationKey
            txtValidateKey.borderColor = .red
            return false
        }
        
        txtValidateKey.borderColor = .gray
        lblErrorMsg.text = ""
        return true
    }
    
    private func startWebView() {
        self.router?.push(scene: .webview)
    }
}

// MARK: - Observers
extension ValidateKeyViewController {
    @objc func textFieldDidChange(_ textField: UITextField) {
        let validations = validateData()
        print(validations)
    }
}

// MARK: - Button Action
extension ValidateKeyViewController {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnValidate:
            if validateData() {
                self.viewModel.validate(key: txtValidateKey.text ?? "")
                btnValidate.loadingIndicator(true)
            }
            
        case btnSideMenu:
            // mak changes use separate func when you are in switch case 2 line is good but it is more than it then use a separate private func as action for the button the way I did for side menu action
            self.sideMenuAction()
        case btnProceed:
            self.startWebView()
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
            lblErrorMsg.text = text
            btnValidate.loadingIndicator(false)
            txtValidateKey.borderColor = .red
        case .validate:
            btnValidate.loadingIndicator(false)
            btnValidate.isUserInteractionEnabled = false
            btnValidate.setTitle("", for: .normal)
            btnValidate.setBackgroundImage(UIImage(named: "ic-mercer-validation-success"), for: .normal)
            self.btnProceed.isHidden = false
        default:
            break
        }
    }
}

// MARK: - Delegate Methods
extension ValidateKeyViewController : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        let alphaNumericRegEx = "[a-zA-Z0-9]"
        let predicate = NSPredicate(format:"SELF MATCHES %@", alphaNumericRegEx)
        return predicate.evaluate(with: string)
    }
}
