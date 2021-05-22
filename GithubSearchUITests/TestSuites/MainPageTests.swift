//
//  MainPageTests.swift
//  GithubSearchUITests
//
//  Created by kuanwei on 2021/5/22.
//

import Foundation

import XCTest

class MainPageTests: XCTestCase {
    let app = XCUIApplication()

    var mainPage: MainPage?

    private let validSearchText = "Swift"

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        app.launch()

        mainPage = MainPage(app: app)
    }

    func testSearchResultDisplay() {
        // Given
        mainPage?.typeSearchText(searchText: validSearchText)

        // When
        mainPage?.searchButton.tap()

        // Then
        let resultCell = app.tables.firstMatch.cells.firstMatch
        Utility.expect(element: resultCell, status: .exist)

        XCTAssert(app.tables.firstMatch.cells.count > 0)
    }

    func testSearchResultClickContent() {
        // Given
        mainPage?.typeSearchText(searchText: validSearchText)
        mainPage?.searchButton.tap()

        // When
        let resultCell = app.tables.firstMatch.cells.firstMatch
        Utility.expect(element: resultCell, status: .exist)
        mainPage?.tapSearchResultItemAtRow(row: 0)

        // Then
        Utility.expect(element: app.navigationBars.firstMatch, status: .exist)
    }
}
