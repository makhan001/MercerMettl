//
//  KeyProceedByViewCoordinator.swift
//  Dev_Mercer_Mettl
//
//  Created by mohd-ali-khan on 17/11/22.
//

import Foundation

final class KeyProceedByViewCoordinator: Coordinator<Scenes> {
    weak var delegate: CoordinatorDimisser?
    let controller: KeyProceedByViewController = KeyProceedByViewController.from(from: .main, with: .keyProceedBy)
    private var validateKey1: ValidatekeyCoordinator!
    private var scanenrKey: ScannerCoordinator!
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
    
    private func startScannerview() {
        let router = Router()
        scanenrKey = ScannerCoordinator(router: router)
        add(scanenrKey)
       // validateKey1.delegate = self
        scanenrKey.start()
        self.router.present(scanenrKey, animated: true)
    }
}

extension KeyProceedByViewCoordinator: NextSceneDismisser {
    func push(scene: Scenes) {
        switch scene {
        case .validate: startValidateview()
        case .scanner: startScannerview()
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

extension KeyProceedByViewCoordinator: CoordinatorDimisser {
    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}
