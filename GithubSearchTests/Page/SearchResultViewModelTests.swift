//
//  SearchResultViewModelTests.swift
//  GithubSearchTests
//
//  Created by kuanwei on 2021/5/15.
//

import XCTest
@testable import GithubSearch

class SearchResultViewModelTests: XCTestCase {

    let sut = SearchResultViewModel()

    func testNumberOfSections() {
        XCTAssertEqual(1, sut.numberOfSections())
    }

    func testNumberOfRows() {
        XCTAssertEqual(0, sut.numberOfRows(inSection: 0))
    }
}
