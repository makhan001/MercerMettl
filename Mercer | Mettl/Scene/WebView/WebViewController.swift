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
            
            // Setup webcallback massage name
            configuration.userContentController.add(self, name: "MercelMettlApp")
            configuration.preferences = preferences
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
}

// MARK: - Callbacks from webview
extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("message.body ====>>>>>  \(message.body)")
        if message.name == "MercelMettlApp", let messageBody2 = message.body as? Any {
            if let dict = messageBody2 as? Dictionary<String, AnyObject> {
                if let eventName = dict["eventName"] {
                  //  showtoast(Message: eventName as! String)
                    
                    if eventName as! String == "showUnlockDialog" {
                        AssessmentManager.shared.endAssessmentMode()
            //self.showAlertController(title: AppConstant.logoutAlertTitle, message: AppConstant.logoutAlertMessage)
            //            UIAccessibility.requestGuidedAccessSession(enabled: false) { didSucceed in
            //               print("Enable App Lock request - \(didSucceed ? "Succeeded" : "Failed")")
            //            }
                        self.showLogoutAlertController(title: AppConstant.logoutAlertTitle, message: AppConstant.logoutAlertMessage, router: router)
                    }
                    
                    if eventName as! String == "enableLockMode" {
                       // let key = "onMessageReceived("\(asd)","\(asd)")"
                       // self.webView.evaluateJavaScript("key")

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
    
    private func callBack(callbackID: Int, success: Bool, reasonOrValue: AnyObject!) {
          
           webView.evaluateJavaScript("Goldengate.callBack(\(callbackID), \(success))", completionHandler: nil)
      }
}

