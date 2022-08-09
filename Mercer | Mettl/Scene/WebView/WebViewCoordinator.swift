//
//  WebViewCoordinator.swift
//  Mercer | Mettl
//
//  Created by mohd-ali-khan on 08/08/22.
//

import Foundation

final class WebViewCoordinator: Coordinator<Scenes> {
    
    weak var delegate: CoordinatorDimisser?
    let controller: WebViewController = WebViewController.from(from: .main, with: .webview)
    
    override func start() {
        super.start()
        self.router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    private func onStart() {
        controller.router = self
    }
    
    func start(strUrl: String) {
        controller.router = self
        controller.webUrl = strUrl
    }
}

extension WebViewCoordinator: NextSceneDismisser {
    func push(scene: Scenes) {
        switch scene {
        case .webview: print("web")
        default: break
        }
    }
    
    func dismiss(controller: Scenes) {
        delegate?.dismiss(coordinator: self)
        //        switch  controller {
        //        case .landing:
        //            router.dismissModule(animated: true, completion: nil)
        //        case .validate:
        //            router.dismissModule(animated: true, completion: nil)
        //        default:
        //            delegate?.dismiss(coordinator: self)
        //        }
    }
}

extension WebViewCoordinator: CoordinatorDimisser {
    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}
