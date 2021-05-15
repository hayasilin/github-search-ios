//
//  SearchTermViewModelTests.swift
//  GithubSearchTests
//
//  Created by kuanwei on 2021/5/15.
//

import XCTest
@testable import GithubSearch

class SearchTermViewModelTests: XCTestCase {

    let sut = SearchTermViewModel()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        DBManager.shared.deleteDatabase()
        DBManager.shared.initDatabase()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        DBManager.shared.deleteDatabase()
        DBManager.shared.initDatabase()
    }
}

extension SearchTermViewModelTests {
    func testNumberOfSections() {
        XCTAssertEqual(1, sut.numberOfSections())
    }

    func testNumberOfRows() {
        sut.recentSearchTermList = []

        XCTAssertEqual(0, sut.numberOfRows(inSection: 0))
    }

    func testIsEmpty() {
        sut.recentSearchTermList = []

        XCTAssertTrue(sut.isEmpty())
    }
}
