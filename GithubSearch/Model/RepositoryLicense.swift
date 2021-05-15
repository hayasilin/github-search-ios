//
//  RepositoryLicense.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation

public struct RepositoryLicense: Codable {
    public let key : String?
    public let name : String?
    public let spdxId : String?
    public let url : String?
    public let nodeId: String?

    enum CodingKeys: String, CodingKey {
        case key
        case name
        case spdxId = "spdx_id"
        case url
        case nodeId = "node_id"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        key = try values.decodeIfPresent(String.self, forKey: .key)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        spdxId = try values.decodeIfPresent(String.self, forKey: .spdxId)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        nodeId = try values.decodeIfPresent(String.self, forKey: .nodeId)
    }
}
