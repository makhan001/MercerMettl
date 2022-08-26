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
    @IBOutlet weak var btnProceed: UIButton!
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var btnValidate: UIButton!
    @IBOutlet weak var lblProvideKey: UILabel!
    @IBOutlet weak var imgSidemenuBar: UIImageView!
    @IBOutlet weak var txtValidateKey: UITextField!
    @IBOutlet weak var lblMercerAssessment: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    let viewModel = ValidateKeyViewModel(provider: OnboardingServiceProvider())
    weak var router: NextSceneDismisser?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - Instance Method
extension ValidateKeyViewController {
    private func setup() {
        self.viewModel.view = self
        self.activityIndicatorView.isHidden = true
        self.configureButton()
        self.configureLabel()
        self.configureTextField()
        startPendoSession(visitorid: PendoConfiguration.visitorId)
    }
    private func configureTextField() {
        self.txtValidateKey.delegate = self
        switch APIEnvironment {
        case .dev:
            // self.txtValidateKey.text = "369flx4jcw"
        self.txtValidateKey.text =   "4cvno5m0ao"
        case .production:
            // self.txtValidateKey.text = "3xjj9m1yps"   // With proctoring key
        self.txtValidateKey.text =   "4cvno5m0ao"  // Without proctoring key
            // self.txtValidateKey.text = "3xhd8cqz28" // Without proctoring key
        case .staging:
            self.txtValidateKey.text = "3r1m8yxiww"
          //  self.txtValidateKey.text =   "4cvno5m0ao"
        }
        self.txtValidateKey.font = UIFont.setFont(fontType: .regular, fontSize: .semimedium)
        self.txtValidateKey.setLeftPaddingPoints(10.0)
        self.txtValidateKey.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
      }
    private func configureLabel() {
        self.lblWelcome.font = UIFont.setFont(fontType: .light, fontSize: .large)
        self.lblMercerAssessment.font = UIFont.setFont(fontType: .medium, fontSize: .vxllarge)
        self.lblProvideKey.font = UIFont.setFont(fontType: .regular, fontSize: .mediumSmall)
        self.lblErrorMsg.font = UIFont.setFont(fontType: .regular, fontSize: .small)
    }
    private func configureButton() {
        self.btnValidate.titleLabel?.font =  UIFont.setFont(fontType: .regular, fontSize: .semimedium)
        self.btnProceed.titleLabel?.font =  UIFont.setFont(fontType: .medium, fontSize: .medium)
        self.imgSidemenuBar.image = UIImage.fontAwesomeIcon(name: FontAwesome.bars,
                                                            style: .solid,
                                                            textColor: UIColor.setColor(colorType: .skyDark),
                                                            size: CGSize(width: 30, height: 30))
        [ btnValidate, btnSideMenu, btnProceed].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
    private func validateData() -> Bool {
        self.txtValidateKey.borderWidth = 1
        self.txtValidateKey.layer.cornerRadius = 5
        guard let text = txtValidateKey.text, text != "" else {
            lblErrorMsg.text = AppConstant.emptyInvitationKey
            txtValidateKey.borderColor = UIColor.setColor(colorType: .primeryRed)
            return false
        }
        guard let text = txtValidateKey.text, text.count > 6 else {
            lblErrorMsg.text = AppConstant.incorrectInvitationKey
            txtValidateKey.borderColor = UIColor.setColor(colorType: .primeryRed)
            return false
        }
        self.txtValidateKey.borderColor = .gray
        self.lblErrorMsg.text = ""
        return true
    }
    private func startWebView() {
        self.router?.push(scene: .webview)
    }
    private func showIndicator(_ show: Bool, _ onAPISuccess: Bool = true) {
        self.btnValidate.setTitle("", for: .normal)
        show ? self.activityIndicatorView.startAnimating() : self.activityIndicatorView.stopAnimating()
        self.activityIndicatorView.isHidden = !show
        if !onAPISuccess {
            self.btnValidate.setTitle("Retry", for: .normal)
        }
        self.btnValidate.isHidden = show
    }
}

// MARK: - Observers
extension ValidateKeyViewController {
    @objc func textFieldDidChange(_ textField: UITextField) {
        let validations = validateData()
        print(validations)
    }
}

// MARK: - Textfield Delegate
extension ValidateKeyViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let length =  (textField.text?.count ?? 0) +  (string.count - range.length)
        if length > 20 {
            return false
        }
        self.btnProceed.isHidden = true
        self.btnValidate.isUserInteractionEnabled = true
        self.btnValidate.titleLabel?.font  = UIFont.setFont(fontType: .regular, fontSize: .semimedium)
        self.btnValidate.setTitle("Validate Key", for: .normal)
        self.btnValidate.setImage(nil, for: .normal)
        self.btnValidate.setTitleColor(UIColor.setColor(colorType: .primaryBlueDark), for: .normal)
        if string.isEmpty {
            return true
        }
        let alphaNumericRegEx = "[a-zA-Z0-9]"
        let predicate = NSPredicate(format: "SELF MATCHES %@", alphaNumericRegEx)
        return predicate.evaluate(with: string)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }
}

// MARK: - Button Action
extension ValidateKeyViewController {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnValidate:
            self.validateKeyAction()
        case btnSideMenu:
            self.sideMenuAction()
        case btnProceed:
            self.startWebView()
        default:
            break
        }
    }
    private func validateKeyAction() {
        if validateData() {
            self.viewModel.validate(key: txtValidateKey.text ?? "")
            self.showIndicator(true)

        }
    }
    private func sideMenuAction() {
        // swiftlint:disable line_length
        guard let menu = self.storyboard?.instantiateViewController(withIdentifier: "Left_menu") as? SideMenuNavigationController
        else { return }
        menu.menuWidth = self.view.frame.width - 10
        menu.presentationStyle = .menuSlideIn
        menu.leftSide = true
        present(menu, animated: true, completion: nil)
    }
    private func validateKey() {
        if validateData() {
            print("Yeah its done")
        }
    }
    private func updateViewAfterValidateKey() {
        if viewModel.webUrl != "", viewModel.webUrl.count > 1 {
            self.showIndicator(false)
            self.btnValidate.isUserInteractionEnabled = false
            self.btnValidate.setTitle("", for: .normal)
            btnValidate.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
            btnValidate.setTitle(String.fontAwesomeIcon(name: .checkCircle), for: .normal)
            btnValidate.setTitleColor(.green, for: .normal)
            self.btnProceed.isHidden = false
        } else {
            self.btnValidate.isUserInteractionEnabled = true
            self.showIndicator(false, false)
        }
    }
}

// MARK: - API Callbacks
extension ValidateKeyViewController: OnboardingViewRepresentable {
    func onAction(_ action: OnboardingAction) {
        switch action {
        case let .errorMessage(text), let .requireFields(text: text):
            self.lblErrorMsg.text = text
            self.txtValidateKey.borderColor = UIColor.setColor(colorType: .primeryRed)
            self.showIndicator(false, false)
        case .validate:
            self.updateViewAfterValidateKey()
        default:
            break
        }
    }
}
