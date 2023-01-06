//
//  ScannerCoordinator.swift
//  Mercer | Mettl
//
//  Created by mohd-ali-khan on 01/12/22.
//

import Foundation

final class ScannerCoordinator: Coordinator<Scenes> {

    weak var delegate: CoordinatorDimisser?
    let controller: ScannerViewController = ScannerViewController.from(from: .main, with: .scannerView)
    private var webview: WebViewCoordinator!

    override func start() {
        super.start()
        self.router.setRootModule(controller, hideBar: true)
        self.onStart()
    }

    private func onStart() {
        controller.router = self
    }

    private func startWebview() {
        let router = Router()
        webview = WebViewCoordinator(router: router)
        add(webview)
        webview.delegate = self
        webview.start()
        webview.start(strUrl: controller.viewModel.ScannedWebUrl)
        self.router.present(webview, animated: true)
    }
}

extension ScannerCoordinator: NextSceneDismisser {
    func push(scene: Scenes) {
        switch scene {
        case .webview: startWebview()
        default: break
        }
    }

    func dismiss(controller: Scenes) {
        switch  controller {
        case .webview: router.dismissModule(animated: true, completion: nil)
        default:
            delegate?.dismiss(coordinator: self)
        }
    }
}

extension ScannerCoordinator: CoordinatorDimisser {
    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}
