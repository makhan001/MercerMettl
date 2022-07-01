//
//  ViewController.swift
//  Mercer | Mettl
//
//  Created by m@k on 14/04/22.
//

import UIKit

class LandingViewController: UIViewController {
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lblGetStarted: UILabel!
    @IBOutlet weak var lblMercerMettl: UILabel!
    @IBOutlet weak var btnGetStarted: UIButton!
    @IBOutlet weak var imgRightArrow: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
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
    }
    
    private func configureFonts() {
        self.lblWelcome.font = UIFont.setFont(fontType: .light, fontSize: .large)
        self.lblMercerMettl.font = UIFont.setFont(fontType: .regular, fontSize: .vxllarge)
        self.lblGetStarted.font = UIFont.setFont(fontType: .medium, fontSize: .medium)
        self.imgRightArrow.image = UIImage.fontAwesomeIcon(name:FontAwesome.arrowRight, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
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
        router?.push(scene: .validate)
    }
}

//sfasasd as dasd asd asd d
// MARK: - Closure and Delegate Callbacks
extension LandingViewController {
    func didScrolledAtIndex(_ index: Int) {
        self.pageControl.currentPage = index
    }
}
