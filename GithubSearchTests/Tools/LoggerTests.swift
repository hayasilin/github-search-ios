//
//  LoggerTests.swift
//  GithubSearchTests
//
//  Created by kuanwei on 2021/5/15.
//

import XCTest
@testable import GithubSearch

class LoggerTests: XCTestCase {
    func testLogger() {

        // create an expectation for a background async task.
        let expectation = XCTestExpectation(description: #function)
        let closure = {() -> String in
            expectation.fulfill()
            return "logger complete"
        }

        Logger.log(closure(), level: .info)

        // wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
    }

}
