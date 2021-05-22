//
//  ImageDataProvider.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/22.
//

import UIKit

protocol ImageDataProvider where Self: Operation {
    var image: UIImage? { get }
}
