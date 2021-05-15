//
//  ArrayExtension.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        return 0 <= index && index < count ? self[index] : nil
    }
}
