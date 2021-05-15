//
//  GithubRepositoryItemTests.swift
//  GithubSearchTests
//
//  Created by kuanwei on 2021/5/15.
//

import XCTest
@testable import GithubSearch

class GithubRepositoryItemTests: XCTestCase {
    func testDecodeSuccessResponse() throws {
        let data = (try APITests.testDataFromJSON(fileName: "GithubRepositoryItemSuccess"))!
        let result = try JSONDecoder().decode(GithubRepositoryItem.self, from: data)

        XCTAssertEqual("XCGLogger", result.name)

        XCTAssertEqual("https://avatars.githubusercontent.com/u/1012467?v=4", result.owner?.avatarUrl)

        XCTAssertEqual("MIT License", result.license?.name)
    }
}
