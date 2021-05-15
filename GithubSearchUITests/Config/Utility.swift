//
//  Utility.swift
//  GithubSearchUITests
//
//  Created by kuanwei on 2021/5/15.
//

import XCTest

class Utility: XCTestCase {
    enum UIStatus: String {
        case exist = "exists == true"
        case notExist = "exists == false"
        case selected = "selected == true"
        case notSelected = "selected == false"
        case hittable = "hittable == true"
        case unhittable = "hittable == false"
    }

    static func expect(element: XCUIElement, status: UIStatus, timeout: TimeInterval = UITestConfig.timeout) {
        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: status.rawValue), object: element)
        let result = XCTWaiter.wait(for: [expectation], timeout: timeout)

        if result == .timedOut {
            XCTFail(expectation.description)
        }
    }

    static func tapWithExpect(element: XCUIElement?, status: UIStatus, timeout: TimeInterval = UITestConfig.timeout) {
        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: status.rawValue), object: element)
        let result = XCTWaiter.wait(for: [expectation], timeout: timeout)
        if result == .completed {
            element?.tap()
        }
    }
}
