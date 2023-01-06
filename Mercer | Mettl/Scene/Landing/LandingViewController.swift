//
//  ViewController.swift
//  Mercer | Mettl
//
//  Created by m@k on 14/04/22.
//

import UIKit

class LandingViewController: UIViewController {
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lblMercerMettl: UILabel!
    @IBOutlet weak var btnGetStarted: UIButton!
    @IBOutlet weak var imgRightArrow: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var viewOpenEnvironmentSetup: UIView!
    @IBOutlet weak var collectionView: IntroCollectionView!
    weak var router: NextSceneDismisser?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

// MARK: - Instance Method
extension LandingViewController {
    private func setup() {
        configureFonts()
        configureCollection()
        startPendoSession(visitorid: PendoConfiguration.visitorId)
        [ btnGetStarted ].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        // Open environment bottomSheet
        let tap = UITapGestureRecognizer(target: self, action: #selector(tripleTapped))
           tap.numberOfTapsRequired = 3
        viewOpenEnvironmentSetup.addGestureRecognizer(tap)
    }
    private func configureFonts() {
        self.lblWelcome.font = UIFont.setFont(fontType: .light, fontSize: .large)
        self.lblMercerMettl.font = UIFont.setFont(fontType: .regular, fontSize: .vxllarge)
        self.btnGetStarted.titleLabel?.font = UIFont.setFont(fontType: .medium, fontSize: .medium)
        self.btnGetStarted.setImage(UIImage.fontAwesomeIcon(name: FontAwesome.arrowRight,
                                                            style: .solid,
                                                            textColor: .white,
                                                            size: CGSize(width: 30, height: 15)), for: .normal)
    }
    private func configureCollection() {
        collectionView.configure()
        collectionView.didScrolledAtIndex = didScrolledAtIndex
    }
}

// MARK: - Button Action
extension LandingViewController {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnGetStarted:
            self.getStartedAction()
        default:
            break
        }
    }
    private func getStartedAction() {
        router?.push(scene: .keyProceed)
    }
    // Environment bottomsheet action
    @objc func tripleTapped() {
        openEnvironmentAlert()
    }
    
    private func openEnvironmentAlert() {
        // swiftlint:disable unused_closure_parameter
        let alert = UIAlertController(title: "Select Server(API) Enviroment ",
                                              message: "",
                                              preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Production (Com)",
                                              style: .default,
                                              handler: {(action: UIAlertAction!) in
                            APIEnvironment = .production
                            print(APIEnvironment.host)
                }))
                alert.addAction(UIAlertAction(title: "Staging (Pro)",
                                              style: .default,
                                              handler: {(action: UIAlertAction!) in
                    APIEnvironment = .staging
                    print(APIEnvironment.host)
                }))

                alert.addAction(UIAlertAction(title: "Staging (xyz)",
                                              style: .default,
                                              handler: {(action: UIAlertAction!) in
                    APIEnvironment = .dev
                    print(APIEnvironment.host)
                }))
                alert.addAction(UIAlertAction(title: "Cancel",
                                              style: .destructive,
                                              handler: {(action: UIAlertAction!) in
                    }))
        alert.view.tintColor = UIColor(named: "DarkBlue")
                self.present(alert, animated: true, completion: nil)
    }
}
// MARK: - Closure and Delegate Callbacks
extension LandingViewController {
    func didScrolledAtIndex(_ index: Int) {
        self.pageControl.currentPage = index
    }
}
