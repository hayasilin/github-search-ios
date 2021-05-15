//
//  LoadingIndicatorDisplayable.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import UIKit

protocol LoadingIndicatorDisplayable: AnyObject {
    var spinner: UIActivityIndicatorView? { get set }
    func showLoadingIndicator(delay: TimeInterval)
    func removeLoadingIndicator()
}

extension LoadingIndicatorDisplayable where Self: UIViewController {
    func showLoadingIndicator(delay: TimeInterval = 0) {
        if spinner == nil {
            let activityIndicatorView = UIActivityIndicatorView(style: .medium)
            activityIndicatorView.color = .darkGray
            view.addSubview(activityIndicatorView)
            activityIndicatorView.fixInSuperviewCenter()

            spinner = activityIndicatorView
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.spinner?.startAnimating()
        }
    }

    func removeLoadingIndicator() {
        spinner?.removeFromSuperview()
        spinner = nil
    }
}
