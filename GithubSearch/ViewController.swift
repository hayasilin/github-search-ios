//
//  ViewController.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/14.
//

import UIKit

class ViewController: UIViewController {
    fileprivate enum Constants {
        static let noImageCell = "SearchResultNoImageTableViewCell"
        static let imageCell = "SearchResultWithImageTableViewCell"
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 160
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(
            UINib(nibName: Constants.imageCell, bundle: nil),
            forCellReuseIdentifier: Constants.imageCell
        )
        tableView.register(
            UINib(nibName: Constants.noImageCell, bundle: nil),
            forCellReuseIdentifier: Constants.noImageCell
        )
        return tableView
    }()

    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Input search keyword"
        searchController.searchBar.sizeToFit()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        return searchController
    }()

    lazy var searchButton: UIButton = {
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        searchButton.setImage(UIImage(named: "icSearch"), for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        searchButton.accessibilityIdentifier = UITestIdentifierConfig.searchButton.rawValue
        return searchButton
    }()

    lazy var searchBarButtonItem: UIBarButtonItem = {
        let searchBarButtonItem = UIBarButtonItem(customView: searchButton)
        return searchBarButtonItem
    }()

    var searchCoordinator: SearchCoordinator?

    lazy var viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItems = [searchBarButtonItem]

        view.addSubview(tableView)
        tableView.pinEdgesToSuperviewEdges()

        tableView.tableHeaderView = searchController.searchBar

        binding()
    }

    private func binding() {
        viewModel.searchResultRepositoryListDidChange = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    @objc func searchButtonTapped(_ sender: UIButton) {
        showSearchPage()
    }

    private func showSearchPage() {
        let searchCoordinator = SearchCoordinator(delegate: self)
        self.searchCoordinator = searchCoordinator
        let searchNavigationController = searchCoordinator.navigationController
        searchNavigationController.modalPresentationStyle = .fullScreen
        navigationController?.present(searchNavigationController, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let repository = viewModel.repositoryItem(at: indexPath) else {
            return UITableViewCell()
        }

        let thumbnailURL = viewModel.thumbnailURL(of: repository)

        let cellIdentifier = (thumbnailURL != nil)
            ? Constants.imageCell
            : Constants.noImageCell

        let cell: SearchResultTableViewCell = tableView.shortDequeueCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.titleLabel.attributedText = viewModel.title(of: repository)
        cell.detailLabel.attributedText = viewModel.detailText(of: repository)
        cell.contentProviderLabel.text = viewModel.contentProvider(of: repository)
        cell.dateLabel.text = viewModel.dateString(of: repository)
        cell.setupImage(with: thumbnailURL)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let url = viewModel.repositoryURL(at: indexPath) {
            let viewModel = SimpleWebViewModel(url: url, title: url.absoluteString)
            let webVC = SimpleWebViewController(viewModel: viewModel)
            navigationController?.pushViewController(webVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.willDisplay(indexPath: indexPath)
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text,
              searchTerm != "" else {
            return
        }

        viewModel.request(searchTerm)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension ViewController: SearchCoordinatorDelegate {
    func searchCoordinatorDidSelectCancel(_ coordinator: SearchCoordinator) {
        dismiss(animated: true, completion: nil)
    }
}
