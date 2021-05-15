//
//  UIView+AutoLayout.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import UIKit

extension UIView {
    @discardableResult func pinEdgesToSuperviewEdges() -> [NSLayoutConstraint] {
        return pinEdgesToSuperviewEdges(withInsets: .zero)
    }

    @discardableResult func pinEdgesToSuperviewEdges(withInsets insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        guard let superview = superview else {
            return []
        }

        translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            leftAnchor.constraint(equalTo: superview.leftAnchor, constant: insets.left),
            rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -insets.right),
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom),
        ]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    @discardableResult func fixInSuperviewCenter() -> [NSLayoutConstraint] {
        guard let superview = superview else {
            return []
        }

        translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    @discardableResult func fixToSize(_ size: CGSize) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height),
        ]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
}

extension UIViewController {
    func backwardCompatibleSafeAreaTopAnchor() -> NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.topAnchor
        } else {
            return topLayoutGuide.bottomAnchor
        }
    }

    func backwardCompatibleSafeAreaBottomAnchor() -> NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomLayoutGuide.topAnchor
        }
    }
}
