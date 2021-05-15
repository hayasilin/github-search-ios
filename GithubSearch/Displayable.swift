//
//  Displayable.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import UIKit

protocol Displayable {
}

extension Displayable {
    func display(_ childVC: UIViewController?, under parentVC: UIViewController?) {
        guard let childVC = childVC, let parentVC = parentVC else { return }
        display(childVC, under: parentVC, at: parentVC.view)
    }

    func display(_ childVC: UIViewController?, under parentVC: UIViewController?, at view: UIView?) {
        guard let childVC = childVC, let parentVC = parentVC, let view = view else { return }
        parentVC.addChild(childVC)
        view.addSubview(childVC.view)
        childVC.didMove(toParent: parentVC)
    }

    func remove(_ childVC: UIViewController?) {
        guard let childVC = childVC else { return }
        childVC.willMove(toParent: nil)
        childVC.view.removeFromSuperview()
        childVC.removeFromParent()
    }
}
