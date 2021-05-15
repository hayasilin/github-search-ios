//
//  SearchPage.swift
//  GithubSearchUITests
//
//  Created by kuanwei on 2021/5/15.
//

import XCTest

class SearchPage {
    var app: XCUIApplication

    lazy var searchButton: XCUIElement = {
        app.keyboards.buttons["Search"]
    }()

    lazy var clearButton: XCUIElement = {
        app.searchFields.firstMatch.buttons.firstMatch
    }()

    lazy var cancelButton: XCUIElement = {
        app.navigationBars.buttons["Cancel"]
    }()

    lazy var deleteAllButton: XCUIElement = {
        app.buttons["Delete all"]
    }()

    lazy var deleteButton: XCUIElement = {
        app.tables[UITestIdentifierConfig.searchTermTableView.rawValue].cells.buttons[UITestIdentifierConfig.searchTermDeleteButton.rawValue].firstMatch
    }()

    lazy var latestButton: XCUIElement = {
        app.buttons["Updated"]
    }()

    lazy var mostRelatedButton: XCUIElement = {
        app.buttons["Stars"]
    }()

    init(app: XCUIApplication) {
        self.app = app
    }

    func typeSearchText(searchText: String) {
        app.searchFields.firstMatch.typeText(searchText)
    }

    func swipeUpSearchResult() {
        app.tables[UITestIdentifierConfig.searchResultTableView.rawValue].swipeUp()
    }

    func tapSearchResultItemAtRow(row: Int) {
        app.tables[UITestIdentifierConfig.searchResultTableView.rawValue].cells.element(boundBy: row).tap()
    }
}
