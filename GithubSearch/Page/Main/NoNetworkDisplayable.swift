//
//  NoNetworkDisplayable.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation
import UIKit

protocol NoNetworkDisplayable: AnyObject {
    var noNetworkView: NoNetworkView? { get set }

    func showNoNetworkView()

    func removeNoNetworkView()
}

extension NoNetworkDisplayable where Self: UIViewController, Self: NoNetworkViewDelegate {
    func showNoNetworkView() {
        guard self.noNetworkView == nil else {
            return
        }

        let noNetworkView = NoNetworkView(
            title: "Not connected to internet",
            detail: "Please check your connection",
            buttonTitle: "Retry"
        )
        noNetworkView.delegate = self
        view.addSubview(noNetworkView)
        noNetworkView.pinEdgesToSuperviewEdges()
        self.noNetworkView = noNetworkView
    }

    func removeNoNetworkView() {
        noNetworkView?.removeFromSuperview()
        noNetworkView = nil
    }
}
