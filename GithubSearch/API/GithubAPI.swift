//
//  GithubAPI.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation

enum GithubAPIHeaderKey {
    static let accept = "Accept"
}

enum GithubAPIEndpoint {
    private static let search = "search"
    static let searchRepository = search + "/repositories"
}

enum GithubAPIError: Error {
    case badRequest(message: String?)
    case notAuthorized(message: String?)
    case rateLimitExceeded(message: String?)
    case wrongVersion(message: String?)
    case internalServerError(message: String?)
    case maintenance(message: String?)
    case requiredUpdate(message: String?)
    case duplicatedName(message: String?)
    case invalidName(message: String?)
    case contentProhibited(message: String?)
    case unknown(message: String?)
    case emptyResult

    static func error(errorCode: Int, message: String?) -> GithubAPIError {
        switch errorCode {
        case 400:
            return .badRequest(message: message)
        case 401:
            return .notAuthorized(message: message)
        case 403:
            return .rateLimitExceeded(message: message)
        case 409:
            return .wrongVersion(message: message)
        case 500:
            return .internalServerError(message: message)
        case 503:
            return .maintenance(message: message)
        case 600:
            return .requiredUpdate(message: message)
        default:
            return .unknown(message: message)
        }
    }
}

protocol GithubAPI {
    associatedtype ResponseType: Codable
}

extension GithubAPI where Self: NetworkRequest {
    var baseUrl: String {
        "https://api.github.com/"
    }

    var defaultHeaders: [String: String] {
        let headers = [
            GithubAPIHeaderKey.accept: "application/vnd.github.v3+json",
            ContentType.json.headerField: ContentType.json.headerValue,
        ]

        return headers
    }

    func request(
        success: ((ResponseType) -> Void)?,
        failure: ((Error) -> Void)?
    ) {
        return networkClient.makeRequest(networkRequest: self) { (data: Data?, error: Error?) in
            if let error = error {
                failure?(error)
                return
            }

            guard let data = data else {
                failure?(GithubAPIError.emptyResult)
                return
            }

            do {
                let response = try JSONDecoder().decode(ResponseType.self, from: data)
                success?(response)
            } catch {
                failure?(error)
            }
        }
    }
}
