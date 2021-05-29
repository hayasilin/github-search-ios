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
    private lazy var titleDict: [String: NSAttributedString] = [:]
    private lazy var detailDict: [String: NSAttributedString] = [:]

    private var isLoading = false

    private var offset = 1

    private var searchTerm = ""

    private(set) var searchTermThrottle = ThrottleDebouncer<String>(1.5)

    init() {
        binding()
    }

    func binding() {
        searchTermThrottle.on { [weak self] searchTerm in
            guard let self = self else {
                return
            }
            self.request(searchTerm)
        }
    }

    func numberOfSections() -> Int {
        return 1
    }

    func numberOfRows(inSection section: Int) -> Int {
        return repositoryItems.count
    }

    func search(_ searchTerm: String) {
        searchTermThrottle.receive(searchTerm)
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
            sort: .stars,
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

    private func convertAttributedStrings(repositoryItems: [GithubRepositoryItem]) {
        repositoryItems.forEach {
            if let name = $0.name, let description = $0.descriptionField {
                self.titleDict[name] = try? name.htmlAttributedString(fontSize: 14, r: 0, g: 0, b: 0)
                self.detailDict[description] = try? description.htmlAttributedString(fontSize: 14, r: 134, g: 134, b: 134)
            }
        }
    }
}

extension ViewModel {
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
