//
//  AppDelegate.swift
//  Mercer | Mettl
//
//  Created by m@k on 14/04/22.
//

import UIKit
import WebKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let webView = WKWebView()
    var rootController = RootCoordinator()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initialSetUp()
        return true
    }
    
    // MARK:- UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
//
extension AppDelegate {
    public static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    private func initialSetUp() {
        Thread.sleep(forTimeInterval: 0.5)
        setRootController()
        getUserAgent()
    }
    
    // MARK:- setRootController
    func setRootController() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            self.rootController.start(window: window)
        }
    }
    
    // MARK:- webView UserAgent
    func getUserAgent() {
        webView.evaluateJavaScript("navigator.userAgent", completionHandler: { (result, error) in
            if let unwrappedUserAgent = result as? String {
                UserStore.save(userAgent: unwrappedUserAgent)
            } else {
                print("failed to get the user agent")
            }
        })
    }
}
