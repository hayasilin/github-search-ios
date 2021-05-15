//
//  EmptyDisplayable.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation
import UIKit

protocol EmptyDisplayable: AnyObject {
    var emptyView: EmptyView? { get set }

    func showEmptyView(withText text: String)

    func removeEmptyView()
}

extension EmptyDisplayable where Self: UIViewController {
    func showEmptyView(withText text: String) {
        guard self.emptyView == nil else {
            return
        }

        let emptyView = EmptyView(
            title: text
        )
        view.addSubview(emptyView)
        emptyView.pinEdgesToSuperviewEdges()
        self.emptyView = emptyView
    }

    func removeEmptyView() {
        emptyView?.removeFromSuperview()
        emptyView = nil
    }
}
