//
//  MainPage.swift
//  GithubSearchUITests
//
//  Created by kuanwei on 2021/5/22.
//

import XCTest

class MainPage {
    var app: XCUIApplication

    lazy var searchButton: XCUIElement = {
        app.keyboards.buttons["Search"]
    }()

    lazy var cancelButton: XCUIElement = {
        app.navigationBars.buttons["Cancel"]
    }()

    init(app: XCUIApplication) {
        self.app = app
    }

    func navigateToSearchPage() {
        app.buttons[UITestIdentifierConfig.searchButton.rawValue].tap()
    }

    func typeSearchText(searchText: String) {
        Utility.tapWithExpect(element: app.searchFields.firstMatch, status: .hittable)
        app.searchFields.firstMatch.typeText(searchText)
    }

    func swipeUpSearchResult() {
        app.tables.firstMatch.swipeUp()
    }

    func tapSearchResultItemAtRow(row: Int) {
        app.tables.firstMatch.cells.element(boundBy: row).tap()
    }
}
