//
//  GithubRepositoryResponseTests.swift
//  GithubSearchTests
//
//  Created by kuanwei on 2021/5/15.
//

import XCTest
@testable import GithubSearch

class GithubRepositoryResponseTests: XCTestCase {
    func testDecodeSuccessResponse() throws {
        let data = (try APITests.testDataFromJSON(fileName: "GithubRepositoryResponseSuccess"))!
        let result = try JSONDecoder().decode(GithubRepositoryResponse.self, from: data)

        XCTAssertEqual(47, result.totalCount)

        XCTAssertEqual(false, result.inCompleteResults)

        XCTAssertEqual(7, result.items.count)
    }
}
