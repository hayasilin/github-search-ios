//
//  SearchViewController.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import UIKit

protocol SearchViewControllerDelegate: AnyObject {
    func searchViewControllerDidSelectCancel(_ vc: SearchViewController)
    func searchViewController(_ vc: SearchViewController, didSelectRepository link: URL)
}

class SearchViewController: UIViewController, Displayable {
    init(coordinator: SearchViewControllerDelegate?, viewModel: SearchViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.coordinator = coordinator
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    weak var coordinator: SearchViewControllerDelegate?

    weak var searchResultViewController: SearchResultViewController?

    lazy var viewModel = SearchViewModel()

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        return searchBar
    }()

    lazy var cancelBarButtonItem: UIBarButtonItem = {
        let cancelBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        return cancelBarButtonItem
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setNavigationTitleView()
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        navigationItem.rightBarButtonItem = cancelBarButtonItem
    }

    func setNavigationTitleView() {
        if #available(iOS 11.0, *) {
            let searchBarTitleView = SearchBarTitleView()
            searchBarTitleView.addSubview(searchBar)
            searchBar.pinEdgesToSuperviewEdges()
            navigationItem.titleView = searchBarTitleView
        } else {
            navigationItem.titleView = searchBar
        }
    }

    fileprivate var maxSearchTermLength: Int {
        return 500
    }

    func search(searchTerm: String) {
        searchBar.resignFirstResponder()

        remove(searchResultViewController)

        let vc = SearchResultViewController(
            viewModel: SearchResultViewModel(searchTerm: searchTerm),
            delegate: self
        )
        display(vc, under: self)
        vc.view.pinEdgesToSuperviewEdges()
        searchResultViewController = vc
    }

    @objc func cancelButtonTapped() {
        searchBar.resignFirstResponder()
        coordinator?.searchViewControllerDidSelectCancel(self)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > maxSearchTermLength {
            searchBar.text = searchText.subString(at: NSRange(location: 0, length: maxSearchTermLength))
        }
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        remove(searchResultViewController)
        searchResultViewController = nil
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        search(searchTerm: searchTerm)
    }
}

extension SearchViewController: SearchResultViewControllerDelegate {
    func viewControllerDidSelectRepository(_ vc: SearchResultViewController, articleLink link: URL) {
        coordinator?.searchViewController(self, didSelectRepository: link)
    }
}
