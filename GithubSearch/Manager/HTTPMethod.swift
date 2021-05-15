//
//  HTTPMethod.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum ContentType {
    case none
    case formUrlEncoded
    case json

    var headerValue: String {
        switch self {
        case .none: return ""
        case .formUrlEncoded: return "application/x-www-form-urlencoded; charset=utf-8"
        case .json: return "application/json"
        }
    }

    var headerField: String {
        switch self {
        case .none: return ""
        case .formUrlEncoded: return "Content-Type"
        case .json: return "Content-Type"
        }
    }
}
