//
//  InitiateTestWebViewController.swift
//  Mercer | Mettl
//
//  Created by m@k on 20/04/22.
//

import UIKit
import WebKit
import Lottie

class WebViewController: UIViewController {
    @IBOutlet weak var viewWeb: UIView!
    @IBOutlet weak var loaderAnimationView: AnimationView!
    
    var webView = WKWebView()
    weak var router: NextSceneDismisser?
    var webUrl: String = ""
    var timer = Timer()
    let screenMirrorBgBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterialDark))
    var screenMirroringAlert: UIAlertController?
    
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
        self.loaderViewSetup()
        self.loadWebView()
        self.viewWeb.addSubview(webView)
        startPendoSession(visitorid: PendoConfiguration.visitorId)
        print("webUrl is \(self.webUrl)")
        
        NotificationCenter.default.addObserver(self, selector: #selector(detectScreenCapture), name: UIScreen.capturedDidChangeNotification, object: nil)
        self.initialSetUp()
    }
    private func loadWebView() {
        if let url = URL(string: webUrl) {
            let preferences = WKPreferences()
            let configuration = WKWebViewConfiguration()
            configuration.userContentController.add(self, name: "MercelMettlApp")
            configuration.preferences = preferences
            configuration.allowsInlineMediaPlayback = true
            self.webView = WKWebView(frame: viewWeb.bounds, configuration: configuration)
            self.webView.tintColor = UIColor.setColor(colorType: .primaryBlue)
            webView.customUserAgent = (webView.value(forKey: "userAgent") ?? "") as! String + "/mettlMercerRRMobileApp"
            webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
            let req = NSURLRequest(url: url as URL)
            webView.load(req as URLRequest)
            webView.navigationDelegate = self
        }
    }
    
    private func loaderViewSetup() {
        // 1. Set animation content mode
        self.loaderAnimationView.contentMode = .scaleAspectFit
        // 2. Set animation loop mode
        self.loaderAnimationView.loopMode = .loop
        // 3. Adjust animation speed
        self.loaderAnimationView.animationSpeed = 1
    }
}
// MARK: - Closure and Delegate Callbacks
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        viewWeb.isHidden = true
        self.loaderAnimationView.isHidden = false
        self.loaderAnimationView.play()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewWeb.isHidden = false
        self.loaderAnimationView.stop()
        self.loaderAnimationView.isHidden = true
        self.navigationItem.rightBarButtonItem = nil
        webView.evaluateJavaScript("document.body.style.webkitTouchCallout='none';")
        webView.evaluateJavaScript("document.body.style.webkitUserSelect='none';")
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
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        print("MercelMettlApp MessageBody Callback====>>>>>  \(message.body)")
        if message.name == "MercelMettlApp" {
            if let dict = message.body as? [String: Any] {
                if let eventName = dict["eventName"] as? String {
                    switch MercerMettlWebCallBackActionName(rawValue: eventName) {
                    case .none:
                        showAlertController(title: "CallbackAlert", message: "none")
                        
                    case .SHOWUNLOCKDIALOG:
                        self.showQuitTestAlertController(title: AppConstant.quiteAlertTitle,
                                                         message: AppConstant.quiteAlertMessage,
                                                         router: router)
                        timer.invalidate()
                        
                    case .ENABLELOCKMODE:
                        if checkDeviceMirroring() {
                            showAlertController(title: "Mercer | Mettl", message: AppConstant.mirroringAlertMessage)
                        }
                        else {
                            if UIAccessibility.isGuidedAccessEnabled == false {
                                DispatchQueue.main.async {
                                    UIAccessibility.requestGuidedAccessSession(enabled: true) { didSucceed in
                                        if didSucceed {
                                            self.callJSMethod(actionName: MercerMettlWebActionName.LOCKED)
                                        } else {
                                            self.showAlertController(title: "Mercer | Mettl", message: AppConstant.faildtocerateLockdownMode)
                                        } }
                                }
                            } else {
                                self.callJSMethod(actionName: MercerMettlWebActionName.LOCKED)
                            }
                        }
                        
                    case .SHOWTOAST:
                        showAlertController(title: "CallbackAlert", message: "SHOW_TOAST")

                    case .DISABLELOCKMODE:
                        print("DISABLE_LOCK_MODE")
                        DispatchQueue.main.async {
                            UIAccessibility.requestGuidedAccessSession(enabled: false) { didSucceed in
                                if didSucceed {
                                    self.timer.invalidate()
                                    self.callJSMethod(actionName: MercerMettlWebActionName.UNLOCKEDBYUSER)
                                }
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
                        showAlertController(title: "CallbackAlert", message: "STOP_SCREEN_CAPTURE")
                    case .CLOSEAPP:
                        DispatchQueue.main.async {
                            UIAccessibility.requestGuidedAccessSession(enabled: false) { didSucceed in
                                    self.timer.invalidate()
                                    self.callJSMethod(actionName: MercerMettlWebActionName.UNLOCKEDBYUSER)
                                    self.router?.dismiss(controller: .landing)
                                    self.closeApp()
                            }
                        }
                        
                    case .UPDATEWEBVIEW:
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
        let base64Img = convertImageToBase64String(img: screenshot)
        callJSMethod(actionName: .SCREENIMAGE, data: base64Img)
    }
}

// MARK: - Screen Capture Alert.
extension WebViewController {
    func showScreenCaptureAlertController(title: String, message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let yes = UIAlertAction.init(title: "Start now", style: .default) { _ in
            self.callJSMethod(actionName: MercerMettlWebActionName.SCREENPERMISSIONSUCCESS)
        }
        let noButton = UIAlertAction.init(title: "Cancel", style: .destructive) { _ in
            self.callJSMethod(actionName: MercerMettlWebActionName.SCREENPERMISSIONERROR,
                              data: "{'type':'userDenied/systemDenied','message':'error message'}")
        }
        alert.view.tintColor = UIColor.setColor(colorType: .darkBlue)//UIColor(named: "DarkBlue")
        alert.addAction(yes)
        alert.addAction(noButton)
        self.present(alert, animated: true, completion: nil)
    }
    
// MARK: - Close and minimise app.
    private func closeApp() {
        DispatchQueue.main.asyncAfter(deadline: .now() ) {
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                exit(0)
            }
        }
    }
}

// MARK: - Screen Mirroring Alert.
   extension WebViewController {
       func showScreenMirrorAlert() {
           if screenMirroringAlert == nil {
               screenMirrorBgBlurView.frame = view.bounds
               screenMirroringAlert = UIAlertController(title: "Mercer | Mettl", message: AppConstant.mirroringAlertMessage, preferredStyle: .alert)
               if let alert = screenMirroringAlert {
                   alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { action in
                       self.screenMirroringAlert = nil
                       self.initialSetUp()
                       return
                   }))
                   self.view.addSubview(screenMirrorBgBlurView)
                   self.present(alert, animated: true, completion: nil)
                }
            }
        }
       func dismissScreenMirrorAlert() {
           screenMirrorBgBlurView.removeFromSuperview()
           screenMirroringAlert?.dismiss(animated: false, completion: nil)
           screenMirroringAlert = nil
       }
       private func initialSetUp(){
           if UIScreen.main.isCaptured {
               showScreenMirrorAlert()
           } else {
               DispatchQueue.main.async {
                   self.dismissScreenMirrorAlert()
               }
           }
       }
       
       @objc func detectScreenCapture(_ notification: Notification) {
           self.initialSetUp()
       }
   }
