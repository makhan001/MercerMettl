//
//  File.swift
//  Dev_Mercer_Mettl
//
//  Created by m@k on 18/05/22.
//

import Foundation

final class ValidatekeyCoordinator: Coordinator<Scenes> {
    
    weak var delegate: CoordinatorDimisser?
    let controller: ValidateKeyViewController = ValidateKeyViewController.from(from: .main, with: .validateKey) 
    let webview: WebViewController = WebViewController.from(from: .main, with: .webview)
    
    override func start() {
        super.start()
        self.router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    private func onStart() {
        controller.router = self
        webview.router = self
    }
    
    private func startWebview() {
        self.webview.webUrl = controller.viewModel.webUrl
        self.router.present(webview, animated: true)
    }
}

extension ValidatekeyCoordinator: NextSceneDismisser {
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

extension ValidatekeyCoordinator: CoordinatorDimisser {
    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}

