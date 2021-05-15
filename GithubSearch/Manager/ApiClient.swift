//
//  ApiClient.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation

enum WebserviceError : Error {
    case DataEmptyError
}

protocol SessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension SessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let dataTask = URLSession.shared.dataTask(with: url, completionHandler: completionHandler)
        dataTask.resume()
        return dataTask
    }
}

extension URLSession: SessionProtocol {}

class ApiClient {
    static let shared = ApiClient()
    lazy var session: SessionProtocol = {
        let condig = URLSessionConfiguration.default
        condig.requestCachePolicy = .returnCacheDataElseLoad
        let cache = URLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024)
        condig.urlCache = cache
        return URLSession(configuration: condig)
    }()

    func requestData(_ urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let dataTask = session.dataTask(with: urlRequest, completionHandler: completionHandler)
        dataTask.resume()
    }

    func requestData(_ url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let dataTask = session.dataTask(with: url, completionHandler: completionHandler)
        dataTask.resume()
    }
}
