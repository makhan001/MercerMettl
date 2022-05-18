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

    var webView = WKWebView()
    weak var router: NextSceneDismisser?
    //let url = "https://tests.mettl.pro/v2/"
    //let url = "https://mettl.xyz/v2/"
   // let url = "https://tests.mettl.xyz/v2/"
    var url:String = ""

    
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
        loadWebView()
        self.customView.addSubview(webView)
        print("Url is \(self.url)")
    }

    func assistiveTouch(){
        let assistiveTouch = AssistiveTouchButton(frame: CGRect(x: view.frame.width - 50, y: view.frame.height - 150, width: 40, height: 40))
        assistiveTouch.tintColor = UIColor(named: "DarkBlue")
        assistiveTouch.addTarget(self, action: #selector(tap(sender:)), for: .touchUpInside)
        assistiveTouch.setImage(UIImage(named: "lock1"), for: .normal)
        assistiveTouch.backgroundColor = .white
        assistiveTouch.cornerRadius = 20
        view.addSubview(assistiveTouch)
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
    @objc func tap(sender: UIButton) {
// self.navigationController?.popViewController(animated: true)
        self.router?.dismiss(controller: .validate)
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


