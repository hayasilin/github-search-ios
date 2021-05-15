//
//  ExtraTouchAreaButton.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import UIKit

class ExtraTouchAreaButton: UIButton {
    var extraTouchAreaInsets: UIEdgeInsets = .zero

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let newArea = CGRect(
            x: bounds.origin.x - extraTouchAreaInsets.left,
            y: bounds.origin.y - extraTouchAreaInsets.top,
            width: bounds.size.width + extraTouchAreaInsets.left + extraTouchAreaInsets.right,
            height: bounds.size.height + extraTouchAreaInsets.top + extraTouchAreaInsets.bottom
        )
        return newArea.contains(point)
    }
}
