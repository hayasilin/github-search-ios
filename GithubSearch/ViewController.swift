//
//  ViewController.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/14.
//

import UIKit

class ViewController: UIViewController {

    var searchCoordinator: SearchCoordinator?

    private lazy var searchButton: UIButton = {
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        searchButton.setImage(UIImage(named: "icSearch"), for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return searchButton
    }()

    lazy var searchBarButtonItem: UIBarButtonItem = {
        let searchBarButtonItem = UIBarButtonItem(customView: searchButton)
        return searchBarButtonItem
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItems = [searchBarButtonItem]
    }

    @objc func searchButtonTapped(_ sender: UIButton) {
        let searchCoordinator = SearchCoordinator(delegate: self)
        self.searchCoordinator = searchCoordinator
        let searchNavigationController = searchCoordinator.navigationController
        navigationController?.present(searchNavigationController, animated: true, completion: nil)
    }
}

extension ViewController: SearchCoordinatorDelegate {
    func searchCoordinatorDidSelectCancel(_ coordinator: SearchCoordinator) {
        dismiss(animated: true, completion: nil)
    }
}
