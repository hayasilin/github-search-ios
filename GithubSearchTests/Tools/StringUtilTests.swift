//
//  StringUtilTests.swift
//  GithubSearchTests
//
//  Created by kuanwei on 2021/5/15.
//

import XCTest
@testable import GithubSearch

class StringUtilTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSubstringOfRange() {
        // When
        let subString = "Hello world".subString(at: NSRange(location: 6, length: 5))

        // Then
        XCTAssertEqual(subString, "world")
    }

    func testSubstringOfRangeOutOfBound() {
        // When
        let subString = "Hello world".subString(at: NSRange(location: 6, length: 100))

        // Then
        XCTAssertNil(subString)
    }

    func testBase64Encoded() {
        let base64String = "githubsearch".base64Encoded()
        XCTAssertEqual("Z2l0aHVic2VhcmNo", base64String)
    }
}
