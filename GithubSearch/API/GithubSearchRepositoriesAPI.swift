//
//  GithubSearchRepositoriesAPI.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation

// https://docs.github.com/en/rest/reference/search#search-repositories
// https://docs.github.com/en/rest/reference/search#rate-limit
// URL Example
// https://api.github.com/search/repositories?sort=stars&order=desc&per_page=10&page=1&q=swift+in:name
// Query Example
// q=swift+in:name
// q=user:hayasilin
// q=language:Swift
// q=language:Swift+language:Ruby
class GithubSearchRepositoriesAPI: NetworkRequest, GithubAPI {
    struct RequestParameter {
        let query: String
        let sort: Sort
        let order: Order
        let perPage: Int // Max is 100
        let page: Int // Page number of the results to fetch.

        static let offsetBase = 1 // 1-based...

        func dictionary() -> [String: Any] {
            return [
                "q": query,
                "sort": sort.rawValue,
                "order": order.rawValue,
                "per_page": perPage,
                "page": page
            ]
        }
    }

    enum Sort: String {
        case stars
        case forks
        case helpWantedIssues = "help-wanted-issues"
        case updated
    }

    enum Order: String {
        case desc
        case asc
    }

    struct ResponseType: Codable {
        let totalCount: Int?
        let inCompleteResults: Bool?
        let items: [GithubRepositoryItem]

        enum CodingKeys: String, CodingKey {
            case totalCount = "total_count"
            case inCompleteResults = "incomplete_results"
            case items
        }
    }

    var endpoint: String = GithubAPIEndpoint.searchRepository

    var method: HTTPMethod = .get

    lazy var params: [String : Any] = requestParameter.dictionary()

    let requestParameter: RequestParameter

    init(requestParameter: RequestParameter) {
        self.requestParameter = requestParameter
    }
}
