//
//  SearchResultViewModel.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation

enum SearchSortType {
    case mostRelated
    case latest
}

extension SearchSortType {
    func toAPIKey() -> GithubSearchRepositoriesAPI.Sort {
        switch self {
        case .mostRelated:
            return .stars
        case .latest:
            return .updated
        }
    }
}

class SearchResultViewModel {
    enum Constants {
        static let reloadCount = 20
        static let loadMoreCount = 20
        static let bufferSizeToLoadMore = 4
    }

    var sortType: SearchSortType = .mostRelated {
        didSet {
            if oldValue == sortType {
                return
            }
            reset()
            request()
        }
    }

    var searchResultRepositoryListDidChange: (() -> Void)?

    private let searchTerm: String

    private var dataMaxCount: Int?
    private lazy var repositoryItems: [GithubRepositoryItem] = []
    private lazy var titleDict: [String: NSAttributedString] = [:]
    private lazy var detailDict: [String: NSAttributedString] = [:]

    private var isLoading = false

    private var offset = 1

    init(searchTerm: String = "") {
        self.searchTerm = searchTerm
    }

    func numberOfSections() -> Int {
        return 1
    }

    func numberOfRows(inSection section: Int) -> Int {
        return repositoryItems.count
    }

    func shouldShowHeader(inSection section: Int) -> Bool {
        return numberOfRows(inSection: section) > 0
    }

    func request() {
        let requestParameter = GithubSearchRepositoriesAPI.RequestParameter(
            query: searchTerm,
            sort: sortType.toAPIKey(),
            order: .desc,
            perPage: Constants.reloadCount,
            page: GithubSearchRepositoriesAPI.RequestParameter.offsetBase
        )

        GithubSearchRepositoriesAPI(requestParameter: requestParameter).request { response in
            self.dataMaxCount = response.totalCount
            self.convertAttributedStrings(repositoryItems: response.items)
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
            sort: sortType.toAPIKey(),
            order: .desc,
            perPage: Constants.loadMoreCount,
            page: offset
        )
        GithubSearchRepositoriesAPI(requestParameter: requestParameter).request { response in
            self.isLoading = false
            self.dataMaxCount = response.totalCount
            self.convertAttributedStrings(repositoryItems: response.items)
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

    func emptyResultMessage() -> String {
        return "No Result"
    }

    private func reset() {
        repositoryItems.removeAll()
        titleDict.removeAll()
        detailDict.removeAll()
        dataMaxCount = nil
    }

    private func convertAttributedStrings(repositoryItems: [GithubRepositoryItem]) {
        repositoryItems.forEach {
            if let name = $0.name, let description = $0.descriptionField {
                self.titleDict[name] = try? name.htmlAttributedString(fontSize: 14, r: 0, g: 0, b: 0)
                self.detailDict[description] = try? description.htmlAttributedString(fontSize: 14, r: 134, g: 134, b: 134)
            }
        }
    }
}

extension SearchResultViewModel {
    private static func createIndexPaths(from: Int, to: Int, section: Int) -> [IndexPath] {
        var arr: [IndexPath] = []
        for row in stride(from: from, to: to, by: 1) {
            arr.append(IndexPath(row: row, section: section))
        }
        return arr
    }
}

extension SearchResultViewModel {
    func repositoryItem(at indexPath: IndexPath) -> GithubRepositoryItem? {
        return repositoryItems[safe: indexPath.row]
    }

    func thumbnailURL(of repositoryItem: GithubRepositoryItem) -> URL? {
        guard let avatarUrl = repositoryItem.owner?.avatarUrl else {
            return nil
        }
        return URL(string: avatarUrl)
    }

    func title(of repositoryItem: GithubRepositoryItem) -> NSAttributedString? {
        return titleDict[repositoryItem.name ?? ""]
    }

    func detailText(of repositoryItem: GithubRepositoryItem) -> NSAttributedString? {
        return detailDict[repositoryItem.descriptionField ?? ""]
    }

    func contentProvider(of repositoryItem: GithubRepositoryItem) -> String? {
        return repositoryItem.fullName
    }

    func dateString(of repositoryItem: GithubRepositoryItem) -> String? {
        return "\(repositoryItem.id ?? 0)"
    }

    func repositoryURL(at indexPath: IndexPath) -> URL? {
        let repositoryItem = repositoryItems[safe: indexPath.row]
        return URL(string: repositoryItem?.htmlUrl ?? "")
    }
}
