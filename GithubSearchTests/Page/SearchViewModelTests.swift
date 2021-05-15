//
//  SearchViewModelTests.swift
//  GithubSearchTests
//
//  Created by kuanwei on 2021/5/15.
//

import XCTest
@testable import GithubSearch

class SearchViewModelTests: XCTestCase {
    func testMaxSearchTermLength() {
        let sut = SearchViewModel()

        XCTAssertEqual(500, sut.maxSearchTermLength())
    }
}
