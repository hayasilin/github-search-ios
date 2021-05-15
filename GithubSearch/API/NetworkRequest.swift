//
//  NetworkRequest.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation

protocol NetworkRequest {
    var baseUrl: String { get }
    var endpoint: String { get }

    var method: HTTPMethod { get }
    var params: [String: Any] { get }
    var defaultHeaders: [String: String] { get }
    var customHeaders: [String: String] { get }

    var networkClient: NetworkClientType { get }
}

extension NetworkRequest {
    var method: HTTPMethod { return .get }
    var params: [String: Any] { return [:] }
    var defaultHeaders: [String: String] { return [:] }
    var customHeaders: [String: String] { return [:] }
    var networkClient: NetworkClientType { return NetworkClient() }

    var headers: [String: String] {
        return defaultHeaders.merging(customHeaders) { (_, new) in new }
    }

    var url: String { return baseUrl + endpoint }
}
