//
//  SearchTermViewModel.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation

class SearchTermViewModel {
    var recentSearchTermListDidChange: (() -> Void)?
    var recentSearchTermList: [String]? {
        didSet {
            recentSearchTermListDidChange?()
        }
    }

    func numberOfSections() -> Int {
        return 1
    }

    func numberOfRows(inSection section: Int) -> Int {
        return recentSearchTermList?.count ?? 0
    }

    func isEmpty() -> Bool {
        guard let searchTermList = recentSearchTermList else {
            return true
        }
        return searchTermList.isEmpty
    }

    func getSearchTerm(with indexPath: IndexPath) -> String? {
        guard let searchTermList = recentSearchTermList,
            let searchTerm = searchTermList[safe: indexPath.row] else {
            return nil
        }
        return searchTerm
    }

    func loadRecentSearchTermList() {
        DBManager.shared.retrieveRecentSearchTermList(
            completion: { retrievedSearchTermList in
                self.recentSearchTermList = retrievedSearchTermList
            }
        )
    }

    func add(recentSearchTerm: String) {
        if DBManager.shared.storeRecentSearchTerm(searchTerm: recentSearchTerm) {
            loadRecentSearchTermList()
        }
    }

    func deleteAllRecentSearchTerms() {
        if DBManager.shared.deleteAllRecentSearches() {
            recentSearchTermList = []
        }
    }

    func delete(recentSearchTerm: String) {
        if DBManager.shared.deleteRecentSearchTerm(recentSearchTerm) {
            loadRecentSearchTermList()
        }
    }
}
