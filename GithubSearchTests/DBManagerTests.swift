//
//  DBManagerTests.swift
//  GithubSearchTests
//
//  Created by kuanwei on 2021/5/15.
//

import XCTest
@testable import GithubSearch

class DBManagerTests: XCTestCase {
    override class func setUp() {
        super.setUp()
        // The setUp() class method is called exactly once for a test case, before its first test method is called.
        DBManager.shared.deleteDatabase()
        DBManager.shared.initDatabase()
    }

    override class func tearDown() {
        super.tearDown()
        DBManager.shared.deleteDatabase()
        DBManager.shared.initDatabase()
    }

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}

// MARK: - DBManager Recent Search Tests

extension DBManagerTests {
    func testStoreRetrieveRecentSearchTerm() {
        let searchTerm0 = "searchTerm0"
        let searchTerm1 = "searchTerm1"
        let searchTerm2 = "searchTerm2"

        XCTAssertTrue(DBManager.shared.deleteAllRecentSearches())
        checkSearchTermsInDB(with: [])

        XCTAssertTrue(DBManager.shared.storeRecentSearchTerm(searchTerm: searchTerm0))
        XCTAssertTrue(DBManager.shared.storeRecentSearchTerm(searchTerm: searchTerm1))
        XCTAssertTrue(DBManager.shared.storeRecentSearchTerm(searchTerm: searchTerm2))
        // The latest search term should be index 0
        checkSearchTermsInDB(with: [searchTerm2, searchTerm1, searchTerm0])

        XCTAssertTrue(DBManager.shared.storeRecentSearchTerm(searchTerm: searchTerm0))
        XCTAssertTrue(DBManager.shared.storeRecentSearchTerm(searchTerm: searchTerm2))
        checkSearchTermsInDB(with: [searchTerm2, searchTerm0, searchTerm1])

        XCTAssertTrue(DBManager.shared.deleteAllRecentSearches())
        checkSearchTermsInDB(with: [])
    }

    func testDeleteRecentSearchTerm() {
        let searchTerm0 = "searchTerm0"
        let searchTerm1 = "searchTerm1"
        let searchTerm2 = "searchTerm2"

        XCTAssertTrue(DBManager.shared.deleteAllRecentSearches())
        checkSearchTermsInDB(with: [])

        XCTAssertTrue(DBManager.shared.storeRecentSearchTerm(searchTerm: searchTerm0))
        XCTAssertTrue(DBManager.shared.storeRecentSearchTerm(searchTerm: searchTerm1))
        XCTAssertTrue(DBManager.shared.storeRecentSearchTerm(searchTerm: searchTerm2))
        checkSearchTermsInDB(with: [searchTerm2, searchTerm1, searchTerm0])

        XCTAssertTrue(DBManager.shared.deleteRecentSearchTerm(searchTerm1))
        checkSearchTermsInDB(with: [searchTerm2, searchTerm0])

        XCTAssertTrue(DBManager.shared.deleteRecentSearchTerm(searchTerm2))
        checkSearchTermsInDB(with: [searchTerm0])

        XCTAssertTrue(DBManager.shared.deleteRecentSearchTerm(searchTerm0))
        checkSearchTermsInDB(with: [])
    }

    private func checkSearchTermsInDB(with searchTermList: [String]) {
        let retrievedSearchTermList = getRecentSearchTermListSynchronously()

        XCTAssertEqual(searchTermList.count, retrievedSearchTermList.count)
        for (index, searchTerm) in searchTermList.enumerated() {
            XCTAssertEqual(searchTerm, retrievedSearchTermList[index])
        }
    }

    private func getRecentSearchTermListSynchronously() -> [String] {
        var recentSearchTermList = [String]()

        // create an expectation for a background async task.
        let expectation = XCTestExpectation(description: "Load recent search term list from database")
        DBManager.shared.retrieveRecentSearchTermList(
            completion: { retrievedSearchTermList in
                guard let retrievedSearchTermList = retrievedSearchTermList else {
                    XCTFail()
                    return
                }
                recentSearchTermList = retrievedSearchTermList
                // fulfill the expectation to indicate that the background task has finished successfully.
                expectation.fulfill()
            }
        )

        // wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)

        return recentSearchTermList
    }
}
