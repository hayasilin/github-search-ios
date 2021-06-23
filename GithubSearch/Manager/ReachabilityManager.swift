//
//  ReachabilityManager.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation
import Reachability

struct ReachabilityManager {
    static func networkReachable() -> Bool {
        guard let reachability = Reachability() else {
            // no reachability lib, treat as network reachable
            return true
        }

        switch reachability.connection {
        case .wifi:
            Logger.log("Reachable via WiFi", level: .info)
        case .cellular:
            Logger.log("Reachable via Cellular", level: .info)
        case .none:
            Logger.log("Network not reachable", level: .info)
        }

        return reachability.connection != .none
    }
}
