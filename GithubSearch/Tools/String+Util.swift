//
//  String+Util.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation
import UIKit

extension String {
    func subString(at range: NSRange) -> String? {
        guard count >= range.location + range.length else {
            return nil
        }

        let start = index(startIndex, offsetBy: range.location)
        let end = index(start, offsetBy: range.length)
        return String(self[start..<end])
    }

    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }

    enum StringError: Error {
        case encodingFail
    }

    func htmlAttributedString(
        fontSize: CGFloat,
        r: Int, // 0-255
        g: Int, // 0-255
        b: Int // 0-255
    ) throws -> NSAttributedString {
        let color = "rgb(\(r),\(g),\(b))"
        let styleString = "body, p, li {font-family: '-apple-system'; font-size: \(fontSize)px; color: \(color);}"
        let html = "<!DOCTYPE html><head><style>\(styleString)</style></head><body>\(self)</body></html>"

        guard let data = html.data(using: String.Encoding.utf8) else {
            throw StringError.encodingFail
        }

        return try NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue,
            ],
            documentAttributes: nil
        )
    }

    func decodeJSONString<T: Decodable>(for type: T.Type) -> T? {
        guard let utf8Data = self.data(using: .utf8) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: utf8Data)
    }
}
