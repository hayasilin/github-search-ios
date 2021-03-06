//
//  NetworkClient.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation

protocol NetworkClientType {
    func makeRequest<Request: NetworkRequest>(
        networkRequest: Request,
        completion: @escaping (Data?, Error?) -> Void
    )
}

struct NetworkClient: NetworkClientType {
    func makeRequest<Request: NetworkRequest>(
        networkRequest: Request,
        completion: @escaping (Data?, Error?) -> Void
    ) {
        let apiClient = ApiClient.shared
        guard let url = URL(string: networkRequest.url) else {
            return
        }
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData)
        urlRequest.httpMethod = networkRequest.method.rawValue
        urlRequest.allHTTPHeaderFields = networkRequest.headers

        switch networkRequest.method {
        case .get:
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
               !networkRequest.params.isEmpty {

                urlComponents.queryItems = networkRequest.params.map {
                    URLQueryItem(name: $0.key, value: "\($0.value)")
                }
                urlRequest.url = urlComponents.url
            }
        case .post, .put, .delete:
            if let data = try? JSONSerialization.data(withJSONObject: networkRequest.params, options: []) {
                urlRequest.httpBody = data
            }
        }

        apiClient.requestData(urlRequest) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, WebserviceError.DataEmptyError)
                return
            }

            completion(data, error)
        }
    }
}
