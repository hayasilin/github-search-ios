//
//  SearchCoordinator.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import UIKit

protocol SearchCoordinatorDelegate: AnyObject {
    func searchCoordinatorDidSelectCancel(_ coordinator: SearchCoordinator)
}

class SearchCoordinator: GithubNavigable {
    init(delegate: SearchCoordinatorDelegate) {
        self.delegate = delegate
    }

    weak var delegate: SearchCoordinatorDelegate?

    lazy var navigationController = UINavigationController(rootViewController: rootVC)

    lazy var rootVC = SearchViewController(coordinator: self, viewModel: SearchViewModel())
}

extension SearchCoordinator: SearchViewControllerDelegate {
    func searchViewControllerDidSelectCancel(_ vc: SearchViewController) {
        delegate?.searchCoordinatorDidSelectCancel(self)
    }

    func searchViewController(_ vc: SearchViewController, didSelectRepository link: URL) {
        navigateToRepository(link, animated: true)
    }
}
