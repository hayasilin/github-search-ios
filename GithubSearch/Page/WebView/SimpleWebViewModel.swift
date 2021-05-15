//
//  SimpleWebViewModel.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation
import Reachability

class SimpleWebViewModel {
    var title: String

    var startingURL: URL?

    convenience init() {
        self.init(url: nil, title: "")
    }

    init(url: URL?, title: String) {
        startingURL = url
        self.title = title
    }

    var networkReachable = true {
        didSet {
            networkStateDidChange?(networkReachable)
        }
    }
    var networkStateDidChange: ((Bool) -> Void)?

    func load() {
        networkReachable = ReachabilityManager.networkReachable()
    }

    func reload() {
        networkReachable = ReachabilityManager.networkReachable()
    }
}
