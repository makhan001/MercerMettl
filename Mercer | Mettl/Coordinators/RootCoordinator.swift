//
//  RootCoordinator.swift
//  Mercer | Mettl
//
//  Created by m@k on 26/04/22.
//

import UIKit
import Foundation

class RootCoordinator {
    private var window: UIWindow?
    private var splashCoordinator: SplashCoordinator

    init() {
        splashCoordinator = SplashCoordinator(router: Router())
    }
    func start(window: UIWindow) {
        self.window = window
        splashCoordinator.start()
        window.rootViewController = splashCoordinator.toPresentable()
        window.makeKeyAndVisible()
    }
}
