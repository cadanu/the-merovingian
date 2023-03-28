//
//  WebViewController.swift
//  TheMerovingian
//
//  Created by GDJ on 2023-03-26.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet var webView : WKWebView!
    @IBOutlet var activity : UIActivityIndicatorView!
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activity.isHidden = false
        activity.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activity.isHidden = true
        activity.stopAnimating()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let urlAddress = URL(string: "https://www.patreon.com")
        let url1 = URLRequest(url: urlAddress!)
        webView.load(url1)
        webView.navigationDelegate = self
    }
}
