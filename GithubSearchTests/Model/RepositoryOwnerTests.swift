//
//  RepositoryOwnerTests.swift
//  GithubSearchTests
//
//  Created by kuanwei on 2021/5/15.
//

import XCTest
@testable import GithubSearch

class RepositoryOwnerTests: XCTestCase {
    func testDecodeSuccessResponse() throws {
        let data = (try APITests.testDataFromJSON(fileName: "RepositoryOwnerSuccess"))!
        let result = try JSONDecoder().decode(RepositoryOwner.self, from: data)

        XCTAssertEqual(result.avatarUrl, "https://avatars.githubusercontent.com/u/1012467?v=4")
    }
}
