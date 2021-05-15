//
//  GithubNavigable.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation
import UIKit

protocol GithubNavigable {
    func navigateToRepository(_ url: URL, animated: Bool)

    var navigationController: UINavigationController { get }
}

extension GithubNavigable {
    func navigateToRepository(_ url: URL, animated: Bool) {
        let viewModel = SimpleWebViewModel(url: url, title: url.absoluteString)
        let webVC = SimpleWebViewController(viewModel: viewModel)
        navigationController.pushViewController(webVC, animated: true)
    }
}
