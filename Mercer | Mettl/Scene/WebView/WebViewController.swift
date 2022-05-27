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
        assistiveTouch()
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
        print("webUrl is \(self.webUrl)")
    }
    
    func assistiveTouch(){
        let assistiveTouch = AssistiveTouchButton(frame: CGRect(x: view.frame.width - 50, y: view.frame.height - 150, width: 40, height: 40))
        assistiveTouch.setTitleColor(UIColor.setColor(colorType: .darkBlue), for: .normal)
        assistiveTouch.addTarget(self, action: #selector(tap(sender:)), for: .touchUpInside)
        assistiveTouch.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        assistiveTouch.setTitle(String.fontAwesomeIcon(name: .lockOpen), for: .normal)
        assistiveTouch.backgroundColor = UIColor.setColor(colorType: .skyDark)
        assistiveTouch.cornerRadius = 20
        view.addSubview(assistiveTouch)
    }
    
    private func loadWebView() {
        if let url = URL(string: webUrl) {
            let myURLRequest = URLRequest(url: url)
            self.webView = WKWebView(frame: self.viewWeb.frame)
            self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            if let userAgent = UserStore.userAgent {
                self.webView.customUserAgent = "\(userAgent)\(AppConstant.bypassPath)"
            }
            self.webView.navigationDelegate = self
            self.webView.load(myURLRequest)
            self.getUpdatedUserAgentKey()
        }
    }
    
    private func getUpdatedUserAgentKey() {
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
    @objc func tap(sender: UIButton) {
        self.router?.dismiss(controller: .validate)
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


