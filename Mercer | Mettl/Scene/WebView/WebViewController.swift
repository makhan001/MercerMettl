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
    let url = "https://mettl.xyz/v2/"
    weak var router: NextSceneDismisser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Instance Method
extension WebViewController {
    func setup() {
        let url = URL(string: url)
        let request = URLRequest(url: url!)
        webView = WKWebView(frame: self.customView.frame)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self
        webView.load(request)
        self.customView.addSubview(webView)
        [ btnExit ].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
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
