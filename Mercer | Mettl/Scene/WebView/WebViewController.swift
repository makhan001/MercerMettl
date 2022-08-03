//
//  InitiateTestWebViewController.swift
//  Mercer | Mettl
//
//  Created by m@k on 20/04/22.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var viewWeb: UIView!
    var webView = WKWebView()
    weak var router: NextSceneDismisser?
    var webUrl:String = ""
    var timer = Timer()
    var imgArr = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBarColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent
        
    }
}

// MARK: - Instance Method
extension WebViewController {
    func setup() {
        self.loadWebView()
        self.viewWeb.addSubview(webView)
        startPendoSession(visitorid: PendoConfiguration.visitorId)
        print("webUrl is \(self.webUrl)")
    }
    
    private func loadWebView() {
        if let url = URL(string: webUrl) {
            let preferences = WKPreferences()
            let configuration = WKWebViewConfiguration()
            // let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.viewWeb.frame.height)
            
            // Setup webcallback massage name
            configuration.userContentController.add(self, name: "MercelMettlApp")
            configuration.preferences = preferences
            configuration.allowsInlineMediaPlayback = true
            
            self.webView = WKWebView(frame: view.bounds, configuration: configuration)
            
            // Update userAgent String
            webView.customUserAgent = (webView.value(forKey: "userAgent") ?? "") as! String + "/mettlMercerRRMobileApp"
            webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
            
            // Load url handling
            let req = NSURLRequest(url:url as URL)
            webView.load(req as URLRequest)
            webView.navigationDelegate = self
        }
    }
}

// MARK: - Closure and Delegate Callbacks
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        viewWeb.isHidden = true
        self.view.lock()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewWeb.isHidden = false
        self.view.unlock()
        self.navigationItem.rightBarButtonItem = nil
    }
    
    @available(iOS 15.0, *)
    func webView(_ webView: WKWebView, decideMediaCapturePermissionsFor origin: WKSecurityOrigin, initiatedBy frame: WKFrameInfo, type: WKMediaCaptureType) async -> WKPermissionDecision {
        return .grant
    }
    
}

// MARK: - Callbacks from webview
extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("MercelMettlApp MessageBody Callback====>>>>>  \(message.body)")
        if message.name == "MercelMettlApp", let messageBody2 = message.body as? Any {
            if let dict = messageBody2 as? Dictionary<String, AnyObject> {
                if let eventName = dict["eventName"] as? String{
                    switch MercerMettlWebCallBackActionName(rawValue: eventName) {
                    case .none:
                        print("Enable lock mode")
                    case .SHOW_UNLOCK_DIALOG:
                        self.showLogoutAlertController(title: AppConstant.logoutAlertTitle, message: AppConstant.logoutAlertMessage, router: router)
                        print("imgArr \(imgArr)")
                        timer.invalidate()
                        break
                    case .ENABLE_LOCK_MODE:
                        //                        UIAccessibility.requestGuidedAccessSession(enabled: true) { didSucceed in
                        //                            if didSucceed {
                        //                                self.callJSMethod(actionName: MercerMettlWebActionName.LOCKED)
                        //                                self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
                        //                            }
                        //                        }
                        
                        self.callJSMethod(actionName: MercerMettlWebActionName.LOCKED)
                        self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
                        break
                    case .some(.SHOW_TOAST):
                        print("SHOW_TOAST")
                        break
                    case .some(.DISABLE_LOCK_MODE):
                        print("DISABLE_LOCK_MODE")
                        //                        UIAccessibility.requestGuidedAccessSession(enabled: false) { didSucceed in
                        //                            if didSucceed {
                        //                                print("imgArr\(self.imgArr)")
                        //                                self.timer.invalidate()
                        //                                self.callJSMethod(actionName: MercerMettlWebActionName.UNLOCKED_BY_USER)
                        //                            }
                        //                        }
                        print("imgArr\(self.imgArr)")
                        self.timer.invalidate()
                        self.callJSMethod(actionName: MercerMettlWebActionName.UNLOCKED_BY_USER)
                        break
                    case .some(.ENABLE_SCREEN_CAPTURE):
                        
                        callJSMethod(actionName: MercerMettlWebActionName.SCREEN_PERMISSION_SUCCESS)
                        print("ENABLE_SCREEN_CAPTURE")
                        break
                    case .some(.START_SCREEN_CAPTURE):
                        print("START_SCREEN_CAPTURE")
                        break
                    case .some(.STOP_SCREEN_CAPTURE):
                        print("STOP_SCREEN_CAPTURE")
                        break
                    case .some(.CLOSE_APP):
                        router?.dismiss(controller: .landing)
                        //                        UIAccessibility.requestGuidedAccessSession(enabled: false) { didSucceed in
                        //                            if didSucceed {
                        //                                print("imgArr\(self.imgArr)")
                        //                                self.timer.invalidate()
                        //                                self.callJSMethod(actionName: MercerMettlWebActionName.UNLOCKED_BY_USER)
                        //                                self.router?.dismiss(controller: .landing)
                        //                            }
                        //                        }
                        self.timer.invalidate()
                        self.callJSMethod(actionName: MercerMettlWebActionName.UNLOCKED_BY_USER)
                        self.router?.dismiss(controller: .landing)
                        break
                    case .some(.UPDATE_WEB_VIEW):
                        print("UPDATE_WEB_VIEW")
                        break
                    case .some(.OPEN_LINK):
                        print("OPEN_LINK")
                        break
                    case .some(.DEFAULT):
                        print("DEFAULT")
                        break
                    }
                }
                
                if let data = dict["data"] {
                    if data != nil {
                        if let frequency = data["frequency"] {
                            print("frequency ===>>>>\(frequency)")
                        }
                    }
                }
            }
        }
    }
    
    public func callJSMethod(actionName : MercerMettlWebActionName ) {
        //  callJSMethod(method: "onMessageReceived('locked', '')")
        let functionName = "onMessageReceived('\(actionName.rawValue)', '')"
        callJSMethod(method: functionName)
    }
    
    public func callJSMethod(method : String) {
        webView.evaluateJavaScript(method, completionHandler: {(result,error) in })
    }
    
    @objc func timerAction() {
        guard let screenshot = self.view.captureScreenShot() else { return }
        imgArr.append(screenshot)
        showAlertController(title: "\(imgArr.count)", message: "Capture count")
    }
}

//MARK: - JS to swift Action name
public enum  MercerMettlWebActionName: String {
    case LOCKED = "locked"
    case DENY_BY_USER = "unlocked"
    case UNLOCKED_BY_USER = "unlockedByUser"
    case TEST_RESUME = "testResume"
    case SCREEN_PERMISSION_SUCCESS = "screenPermissionSuccess"
    case SCREEN_PERMISSION_ERROR = "screenPermissionError"
    case SCREEN_IMAGE = "screenImage"
    case SCREEN_IMAGE_ERROR = "screenImageError"
    case SCREEN_PERMISSION_REVOKE = "screenPermissionRevoke"
    case MULTIPLE_SCREEN_DETECTED = "multipleScreenDetected"
}

//MARK: - JS to swift Action name
public enum MercerMettlWebCallBackActionName: String {
    case SHOW_TOAST = "showToast"
    case ENABLE_LOCK_MODE = "enableLockMode"
    case DISABLE_LOCK_MODE = "disableLockMode"
    case SHOW_UNLOCK_DIALOG = "showUnlockDialog"
    case ENABLE_SCREEN_CAPTURE = "enableScreenCapture"
    case START_SCREEN_CAPTURE = "startScreenCapture"
    case STOP_SCREEN_CAPTURE = "stopScreenCapture"
    case CLOSE_APP = "closeApp"
    case UPDATE_WEB_VIEW = "updateWebView"
    case OPEN_LINK = "openLink"
    case DEFAULT = "default"
}
