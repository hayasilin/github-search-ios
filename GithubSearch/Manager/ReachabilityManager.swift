//
//  ReachabilityManager.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation
import Reachability

struct ReachabilityManager {
    static let reachability = Reachability()
    static func networkReachable() -> Bool {
        guard let reachability = reachability else {
            // no reachability lib, treat as network reachable
            return true
        }
        return reachability.connection != .none
    }
}
