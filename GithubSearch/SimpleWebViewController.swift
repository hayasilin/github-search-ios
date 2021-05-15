//
//  SimpleWebViewController.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import UIKit
import WebKit

class SimpleWebViewController: BaseWebViewController {

    lazy var viewModel = SimpleWebViewModel()

    init(viewModel: SimpleWebViewModel, needCustomBackButton: Bool = true) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        title = viewModel.title
        edgesForExtendedLayout = []
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadStartingURL()
    }

    func loadStartingURL() {
        guard let startingURL = viewModel.startingURL else {
            return
        }

        let request = URLRequest(url: startingURL)
        webView.load(request)
    }

    func reload() {
        if webView.url != nil {
            webView.reload()
        } else {
            loadStartingURL()
        }
    }
}

// MARK: WKNavigationDelegate

extension SimpleWebViewController {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }

        if let isWebViewLoadingMainRequest = isWebViewLoadingMainRequest(navigationAction),
            isWebViewLoadingMainRequest == false {
            UIApplication.shared.open(url) { result in
                if result {
                    print("Open External App or Mobile Safari with url: \(url)")
                } else {
                    print("Failed to open url: \(url)")
                }
            }
            decisionHandler(.cancel)
            return
        }

        decisionHandler(.allow)
    }

    private func isWebViewLoadingMainRequest(_ navigationAction: WKNavigationAction) -> Bool? {
        guard let targetURL = navigationAction.request.url else {
            return nil
        }

        if targetURL.absoluteString == webView.url?.absoluteString {
            return true
        }
        return false
    }
}

