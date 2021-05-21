//
//  ViewModel.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/21.
//

import Foundation

class ViewModel {
    enum Constants {
        static let reloadCount = 20
        static let loadMoreCount = 20
        static let bufferSizeToLoadMore = 4
    }

    var searchResultRepositoryListDidChange: (() -> Void)?

    private var dataMaxCount: Int?
    private lazy var repositoryItems: [GithubRepositoryItem] = []

    private var isLoading = false

    private var offset = 1

    private var searchTerm = ""

    func numberOfSections() -> Int {
        return 1
    }

    func numberOfRows(inSection section: Int) -> Int {
        return repositoryItems.count
    }

    func request(_ searchTerm: String) {
        self.searchTerm = searchTerm
        let requestParameter = GithubSearchRepositoriesAPI.RequestParameter(
            query: searchTerm,
            sort: .stars,
            order: .desc,
            perPage: Constants.reloadCount,
            page: GithubSearchRepositoriesAPI.RequestParameter.offsetBase
        )

        GithubSearchRepositoriesAPI(requestParameter: requestParameter).request { response in
            self.dataMaxCount = response.totalCount
            self.repositoryItems = response.items
            self.searchResultRepositoryListDidChange?()
        } failure: { error in
            Logger.log(error.localizedDescription, level: .error)
        }
    }

    func willDisplay(indexPath: IndexPath) {
        if shouldLoadMoreAt(indexPath: indexPath) {
            loadMore()
        }
    }

    private func shouldLoadMoreAt(indexPath: IndexPath) -> Bool {
        if let dataMaxCount = dataMaxCount,
            // still have more data to load
            repositoryItems.count < dataMaxCount
            // if empty, only reload is allowed
            && repositoryItems.isEmpty == false
            // user had scroll over the buffer size
            && (indexPath.row == repositoryItems.count - 1) {
                return true
            } else {
            return false
        }
    }

    private func loadMore() {
        guard !isLoading, hasNextSearchResult() else {
            return
        }
        isLoading = true
        offset += 1
        let requestParameter = GithubSearchRepositoriesAPI.RequestParameter(
            query: searchTerm,
            sort: .stars,
            order: .desc,
            perPage: Constants.loadMoreCount,
            page: offset
        )
        GithubSearchRepositoriesAPI(requestParameter: requestParameter).request { response in
            self.isLoading = false
            self.dataMaxCount = response.totalCount
            self.repositoryItems.append(contentsOf: response.items)
            self.searchResultRepositoryListDidChange?()
        } failure: { error in
            Logger.log(error.localizedDescription, level: .error)
        }
    }

    private func hasNextSearchResult() -> Bool {
        guard let dataMaxCount = dataMaxCount else {
            return false
        }
        return dataMaxCount > repositoryItems.count
    }
}

extension ViewModel {
    func repositoryItem(at indexPath: IndexPath) -> GithubRepositoryItem? {
        return repositoryItems[safe: indexPath.row]
    }

    func repositoryURL(at indexPath: IndexPath) -> URL? {
        let repositoryItem = repositoryItems[safe: indexPath.row]
        return URL(string: repositoryItem?.htmlUrl ?? "")
    }
}
