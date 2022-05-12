//
//  SplashCoordinator.swift
//  Mercer | Mettl
//
//  Created by m@k on 26/04/22.
//

import Foundation

final class SplashCoordinator: Coordinator<Scenes> {
    
    weak var delegate: CoordinatorDimisser?
    private var splash: SplashCoordinator!
    
    let controller: SplashViewController = SplashViewController.from(from: .main, with: .splash)
    
    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: false)
        self.onStart()
    }
    
    private func onStart() {
        controller.router = self
    }
    
    private func startLanding() {
        let router = Router()
        let landing = LandingCoordinator(router: router)
        add(landing)
        landing.delegate = self
        landing.start()
        self.router.present(landing, animated: true)
    }
}

extension SplashCoordinator: NextSceneDismisser {
    func push(scene: Scenes) {
        switch scene {
        case .landing: startLanding()
        default: break
        }
    }
    
    func dismiss(controller: Scenes) {
        router.dismissModule(animated: true, completion: nil)
    }
}

extension SplashCoordinator: CoordinatorDimisser {
    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}

