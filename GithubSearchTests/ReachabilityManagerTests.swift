//
//  ReachabilityManagerTests.swift
//  GithubSearchTests
//
//  Created by kuanwei on 2021/5/15.
//

import XCTest
@testable import GithubSearch

class ReachabilityManagerTests: XCTestCase {

    func testReachability() {
        let reachability = ReachabilityManager.networkReachable()
        XCTAssertNotNil(reachability)
    }
}
