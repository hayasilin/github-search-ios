//
//  RepositoryLicenseTests.swift
//  GithubSearchTests
//
//  Created by kuanwei on 2021/5/15.
//

import XCTest
@testable import GithubSearch

class RepositoryLicenseTests: XCTestCase {
    func testDecodeSuccessResponse() throws {
        let data = (try APITests.testDataFromJSON(fileName: "RepositoryLicenseSuccess"))!
        let result = try JSONDecoder().decode(RepositoryLicense.self, from: data)

        XCTAssertEqual(result.name, "MIT License")
    }
}
