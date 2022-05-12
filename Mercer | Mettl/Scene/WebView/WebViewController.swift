//
//  InitiateTestWebViewController.swift
//  Mercer | Mettl
//
//  Created by m@k on 20/04/22.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var btnExit: UIButton!
    
    var webView = WKWebView()
    //let url = "https://tests.mettl.pro/v2/"
    //let url = "https://mettl.xyz/v2/"
    let url = "https://tests.mettl.xyz/v2/"
    weak var router: NextSceneDismisser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // setup()
    }
}

// MARK: - Instance Method
extension WebViewController {
    func setup() {
        loadWebView()
        self.customView.addSubview(webView)
        [ btnExit ].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
    
    func loadWebView(){
        if let myURL = URL(string: url) {
            let myURLRequest = URLRequest(url: myURL)
            webView = WKWebView(frame: self.customView.frame)
            webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            if let userAgent = UserStore.userAgent {
                webView.customUserAgent = "\(userAgent)\(AppConstant.bypassPath)"
            }
            webView.navigationDelegate = self
            webView.load(myURLRequest)
            getUpdatedUserAgentKey()
        }
    }
    
    func getUpdatedUserAgentKey() {
        webView.evaluateJavaScript("navigator.userAgent", completionHandler: { (result, error) in
            if let unwrappedUserAgent = result as? String {
                print("userAgent: \(UserStore.userAgent ?? "")")
                print("updated userAgent: \(unwrappedUserAgent)")
            } else {
                print("failed to get the user agent")
            }
        })
    }
}

// MARK: - Button Action
extension WebViewController {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnExit:
            self.exitPressed()
        default:
            break
        }
    }
    
    private func exitPressed() {
        self.router?.dismiss(controller: .webview)
    }
}

// MARK: - Closure and Delegate Callbacks
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        customView.isHidden = true
        self.view.lock()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        customView.isHidden = false
        self.view.unlock()
        self.navigationItem.rightBarButtonItem = nil
    }
}
