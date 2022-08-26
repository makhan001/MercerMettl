//
//  SplashViewController.swift
//  Mercer | Mettl
//
//  Created by m@k on 14/04/22.
//

import UIKit

class SplashViewController: UIViewController {
    @IBOutlet weak var imgView: UIImageView!
    var secondsRemaining = 2
    weak var router: NextSceneDismisser?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Instance Method
extension SplashViewController {
    private func setup() {
        #if DEV
        print("Dev. target")
        #elseif PRO
        print("Prod. target")
        #endif
        self.navigationController?.navigationBar.isHidden = true
        self.imgView.alpha = 0
        self.imgView.fadeIn(1.5)
        scheduleTimer()
        startPendoSession(visitorid: PendoConfiguration.visitorId)
    }
    // swiftlint:disable redundant_void_return
    private func scheduleTimer() -> Void {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.secondsRemaining > 0 {
                self.secondsRemaining -= 1
            } else {
                timer.invalidate()
                self.router?.push(scene: .landing)
            }
        }
    }
}
