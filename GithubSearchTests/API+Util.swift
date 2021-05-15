//
//  API+Util.swift
//  GithubSearchTests
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation

class APITests {
    static func testDataFromJSON(fileName: String) throws -> Data? {
        let path = Bundle(for: self).path(forResource: fileName, ofType: "json")!
        let url = URL(fileURLWithPath: path)
        return try Data(contentsOf: url)
    }
}
