//
//  UIColorExtension.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import UIKit

extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xFF) / 255,
            G: CGFloat((hex >> 08) & 0xFF) / 255,
            B: CGFloat((hex >> 00) & 0xFF) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }

    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red) / 255.0
        let newGreen = CGFloat(green) / 255.0
        let newBlue = CGFloat(blue) / 255.0
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }

    convenience init(_ r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }

    convenience init(_ r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}
