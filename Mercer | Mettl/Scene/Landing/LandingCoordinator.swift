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
    private var validateKey1: ValidatekeyCoordinator!
    private var keyProceedBy: KeyProceedByViewCoordinator!

    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    private func onStart() {
        controller.router = self
    }
    private func startValidateview() {
        let router = Router()
        validateKey1 = ValidatekeyCoordinator(router: router)
        add(validateKey1)
        validateKey1.delegate = self
        validateKey1.start()
        self.router.present(validateKey1, animated: true)
    }
    private func startKeyProceedBy() {
        let router = Router()
        keyProceedBy = KeyProceedByViewCoordinator(router: router)
        add(keyProceedBy)
        keyProceedBy.delegate = self
        keyProceedBy.start()
        self.router.present(keyProceedBy, animated: true)
    }
}

extension LandingCoordinator: NextSceneDismisser {
    func push(scene: Scenes) {
        switch scene {
        case .validate: startValidateview()
        case .keyProceed: startKeyProceedBy()
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
