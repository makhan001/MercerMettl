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
    var webUrl: String = ""
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
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}

// MARK: - Instance Method
extension WebViewController {
    func setup() {
        self.assistiveTouch()
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
            self.webView = WKWebView(frame: self.webView.bounds, configuration: configuration)
            self.webView.tintColor = UIColor(named: "PrimaryBlueDark")
            // Update userAgent String
            // swiftlint:disable force_cast
            webView.customUserAgent = (webView.value(forKey: "userAgent") ?? "") as! String + "/mettlMercerRRMobileApp"
            webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
            // Load url handling
            let req = NSURLRequest(url: url as URL)
            webView.load(req as URLRequest)
            webView.navigationDelegate = self
        }
    }
    func assistiveTouch() {
        let assistiveTouch = AssistiveTouchButton(frame: CGRect(x: view.frame.width - 50,
                                                                y: view.frame.height - 300,
                                                                width: 40,
                                                                height: 40))
        assistiveTouch.setTitleColor(UIColor.setColor(colorType: .darkBlue), for: .normal)
        assistiveTouch.addTarget(self, action: #selector(tap(sender:)), for: .touchUpInside)
        assistiveTouch.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        assistiveTouch.setTitle(String.fontAwesomeIcon(name: .lockOpen), for: .normal)
        assistiveTouch.backgroundColor = UIColor.setColor(colorType: .skyDark)
        assistiveTouch.cornerRadius = 20
        view.addSubview(assistiveTouch)
    }
    @objc func tap(sender: UIButton) {
        UIAccessibility.requestGuidedAccessSession(enabled: false) { _ in
            self.timer.invalidate()
            self.callJSMethod(actionName: MercerMettlWebActionName.UNLOCKEDBYUSER)
            self.router?.dismiss(controller: .landing)
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
    func webView(_ webView: WKWebView, decideMediaCapturePermissionsFor
                 origin: WKSecurityOrigin,
                 initiatedBy
                 frame: WKFrameInfo,
                 type: WKMediaCaptureType) async -> WKPermissionDecision {
        return .grant
    }
}

// MARK: - Callbacks from webview
extension WebViewController: WKScriptMessageHandler {
    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_body_length
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        print("MercelMettlApp MessageBody Callback====>>>>>  \(message.body)")
        if message.name == "MercelMettlApp" {
            if let dict = message.body as? [String: Any] {
                if let eventName = dict["eventName"] as? String {
                    switch MercerMettlWebCallBackActionName(rawValue: eventName) {
                    case .none:
                        print("NONE ")
                        showAlertController(title: "CallbackAlert", message: "none")
                    case .SHOWUNLOCKDIALOG:
                        self.showLogoutAlertController(title: AppConstant.logoutAlertTitle,
                                                       message: AppConstant.logoutAlertMessage,
                                                       router: router)
                        timer.invalidate()
                    case .ENABLELOCKMODE:
                        UIAccessibility.requestGuidedAccessSession(enabled: true) { didSucceed in
                            if didSucceed {
                                self.callJSMethod(actionName: MercerMettlWebActionName.LOCKED)
                            } else {
                                self.router?.dismiss(controller: .validate)
                            }
                        }
                    case .SHOWTOAST:
                        print("SHOW_TOAST")
                        showAlertController(title: "CallbackAlert", message: "SHOW_TOAST")
                    case .DISABLELOCKMODE:
                        print("DISABLE_LOCK_MODE")
                        UIAccessibility.requestGuidedAccessSession(enabled: false) { didSucceed in
                            if didSucceed {
                                self.timer.invalidate()
                                self.callJSMethod(actionName: MercerMettlWebActionName.UNLOCKEDBYUSER)
                            }
                        }
                    case .ENABLESCREENCAPTURE:
                        showScreenCaptureAlertController(title: AppConstant.screenCaptureTitle,
                                                         message: AppConstant.screenCaptureMessage)
                    case .STARTSCREENCAPTURE:
                        if let strData = dict["data"] as? String,
                           let data = strData.data(using: .utf8),
                           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let frequency = json["frequency"] as? Double {
                            let seconds = frequency/1000
                            self.timer = Timer.scheduledTimer(timeInterval: seconds,
                                                              target: self,
                                                              selector: #selector(self.screenCaptureAction),
                                                              userInfo: nil,
                                                              repeats: true)
                        }
                    case .STOPSCREENCAPTURE:
                        print("STOP_SCREEN_CAPTURE")
                        showAlertController(title: "CallbackAlert", message: "STOP_SCREEN_CAPTURE")
                    case .CLOSEAPP:
                        // router?.dismiss(controller: .landing)
                        UIAccessibility.requestGuidedAccessSession(enabled: false) { didSucceed in
                            if didSucceed {
                                self.timer.invalidate()
                                self.callJSMethod(actionName: MercerMettlWebActionName.UNLOCKEDBYUSER)
                                self.router?.dismiss(controller: .landing)
                            }
                        }
                    case .UPDATEWEBVIEW:
                        print("UPDATE_WEB_VIEW")
                        showAlertController(title: "CallbackAlert", message: "UPDATE_WEB_VIEW")
                    case .OPENLINK:
                        showAlertController(title: "CallbackAlert", message: "OPEN_LINK")
                    case .some(.DEFAULT):
                        showAlertController(title: "CallbackAlert", message: "DEFAULT")
                    }
                }
            }
        }
    }
    public func callJSMethod(actionName: MercerMettlWebActionName ,
                             data: String = "") {
        //  callJSMethod(method: "onMessageReceived('locked', '')")
        // "onMessageReceived('locked','{'type':'userDenied/systemDenied','message':'error message'}'))"
        let functionName = "onMessageReceived('\(actionName.rawValue)', '\(data)')"
        // showAlertController(title: "screenshot", message:functionName)
        evaluateJSMethod(method: functionName)
    }
    public func evaluateJSMethod(method: String) {
        webView.evaluateJavaScript(method, completionHandler: {(result, error) in
            print(result ?? "")
            print(error ?? "")
        })
    }
    @objc func screenCaptureAction() {
        guard let screenshot = self.view.captureScreenShot() else { return }
        // imgArr.append(screenshot)
        let base64Img = convertImageToBase64String(img: screenshot)
        callJSMethod(actionName: .SCREENIMAGE, data: base64Img)
    }
}
// MARK: - Screen Capture Alert.
extension WebViewController {
    func showScreenCaptureAlertController(title: String, message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let noButton = UIAlertAction.init(title: "Cancel", style: .destructive) { _ in
            self.callJSMethod(actionName: MercerMettlWebActionName.SCREENPERMISSIONERROR,
                              data: "{'type':'userDenied/systemDenied','message':'error message'}")
        }
        let yes = UIAlertAction.init(title: "Start now", style: .default) { _ in
            self.callJSMethod(actionName: MercerMettlWebActionName.SCREENPERMISSIONSUCCESS)
        }
        alert.view.tintColor = UIColor(named: "DarkBlue")
        alert.addAction(yes)
        alert.addAction(noButton)
        self.present(alert, animated: true, completion: nil)
    }
}
