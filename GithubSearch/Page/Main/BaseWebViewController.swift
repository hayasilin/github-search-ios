//
//  BaseWebViewController.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation
import UIKit
import WebKit

class BaseWebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        return WKWebView(frame: .zero, configuration: configuration)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)
        webView.pinEdgesToSuperviewEdges()

        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
}
