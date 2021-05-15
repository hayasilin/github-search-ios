//
//  SearchPageTests.swift
//  GithubSearchUITests
//
//  Created by kuanwei on 2021/5/15.
//

import XCTest

class SearchPageTests: XCTestCase {
    let app = XCUIApplication()

    var searchPage: SearchPage?

    private let validSearchText = "Swift"

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        app.launch()

        searchPage = SearchPage(app: app)
    }

    func testSearchResultDisplay() {
        // Given
        searchPage?.typeSearchText(searchText: validSearchText)

        // When
        searchPage?.searchButton.tap()

        // Then
        let resultCell = app.tables[UITestIdentifierConfig.searchResultTableView.rawValue].cells.firstMatch
        Utility.expect(element: resultCell, status: .exist)

        XCTAssert(app.tables[UITestIdentifierConfig.searchResultTableView.rawValue].cells.count > 0)
    }

    func testSearchResultClickContent() {
        // Given
        searchPage?.typeSearchText(searchText: validSearchText)

        // When
        searchPage?.searchButton.tap()
        let resultCell = app.tables[UITestIdentifierConfig.searchResultTableView.rawValue].cells.firstMatch
        Utility.expect(element: resultCell, status: .exist)
        searchPage?.tapSearchResultItemAtRow(row: 0)

        // Then
        Utility.expect(element: app.navigationBars.firstMatch, status: .exist)
    }
}
