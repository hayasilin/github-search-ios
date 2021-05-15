//
//  GithubRepositoryResponse.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation

class GithubRepositoryResponse: Codable {
    let totalCount: Int?
    let inCompleteResults: Bool?
    let items: [RepositoryItem]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case inCompleteResults = "incomplete_results"
        case items
    }
}
