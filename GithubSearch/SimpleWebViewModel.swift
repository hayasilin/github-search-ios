//
//  SimpleWebViewModel.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation

class SimpleWebViewModel {
    var title: String

    var startingURL: URL?

    convenience init() {
        self.init(url: URL(string: "")!, title: "")
    }

    init(url: URL, title: String) {
        startingURL = url
        self.title = title
    }
}
