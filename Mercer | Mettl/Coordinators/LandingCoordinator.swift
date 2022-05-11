//
//  LandingCoordinator.swift
//  Mercer | Mettl
//
//  Created by m@k on 26/04/22.
//

import Foundation

final class LandingCoordinator: Coordinator<Scenes> {

    weak var delegate: CoordinatorDimisser?
    let controller: LandingViewController = LandingViewController.from(from: .main, with: .landing)
    let webview: WebViewController = WebViewController.from(from: .main, with: .webview)
   // private var signup: SignupCoordinator!

    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }

    private func onStart() {
        controller.router = self
        webview.router = self
    }

//      private func startSignup() {
//          signup = SignupCoordinator(router: Router())
//          add(signup)
//          signup.delegate = self
//          signup.start()
//          self.router.present(signup, animated: true)
//      }

  private func startWebview() {
      self.router.present(webview, animated: true)
  }
}

extension LandingCoordinator: NextSceneDismisser {
    func push(scene: Scenes) {
        switch scene {
        case .webview: startWebview()
        default: break
        }
    }

    func dismiss(controller: Scenes) {
        switch  controller {
        case .webview:
            router.dismissModule(animated: true, completion: nil)
        default:
            delegate?.dismiss(coordinator: self)
        }
    }
}

extension LandingCoordinator: CoordinatorDimisser {
    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}

