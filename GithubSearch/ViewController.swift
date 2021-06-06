//
//  ViewController.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/14.
//

import UIKit

class ViewController: UIViewController, Displayable {
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
        tableView.separatorStyle = .none
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

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Input search keyword"
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

    var searchTermViewController: SearchTermViewController?

    var searchCoordinator: SearchCoordinator?

    lazy var viewModel = ViewModel()

    private let queue = OperationQueue()
    private var operations: [IndexPath: Operation] = [:]

    private let imageCache = NSCache<NSURL, UIImage>()

    var maxSearchTermLength: Int {
        return viewModel.maxSearchTermLength()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true

        navigationItem.rightBarButtonItems = [cancelBarButtonItem, searchBarButtonItem]

        binding()

        configureSearchBar()
        configureSearchTermPage()
        configureSearchResultTableView()
    }

    private func binding() {
        viewModel.searchResultRepositoryListDidChange = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    func configureSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }

    func configureSearchTermPage() {
        remove(searchTermViewController)
        let searchTermVC = SearchTermViewController()
        searchTermVC.userDidClick = { [weak self] searchTerm in
            guard let self = self else { return }
            self.searchBar.text = searchTerm
            self.viewModel.search(searchTerm)
            self.remove(self.searchTermViewController)
        }
        display(searchTermVC, under: self)
        searchTermVC.view.pinEdgesToSuperviewEdges()
        searchTermViewController = searchTermVC
    }

    func configureSearchResultTableView() {
        view.addSubview(tableView)
        tableView.pinEdgesToSuperviewEdges()
    }

    func search(searchTerm: String) {
        guard searchTerm != "" else {
            return
        }

        remove(searchTermViewController)
        viewModel.search(searchTerm)
    }

    @objc func cancelButtonTapped() {
        searchBar.resignFirstResponder()

        configureSearchTermPage()
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

        if let url = thumbnailURL {
            // If the image is in cache, use it
            if let image = imageCache.object(forKey: url as NSURL) {
                cell.display(image: image)
                return cell
            }

            let networkImageOperation = NetworkImageOperation(url: url)
            networkImageOperation.onImageProcessed = { image in
                if let image = image {
                    cell.display(image: image)
                    self.imageCache.setObject(image, forKey: url as NSURL)
                }
            }

            queue.addOperation(networkImageOperation)

            if let existingOperation = operations[indexPath] {
                existingOperation.cancel()
            }

            operations[indexPath] = networkImageOperation
        }

        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
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

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > maxSearchTermLength {
            searchBar.text = searchText.subString(at: NSRange(location: 0, length: maxSearchTermLength))
        }

        if !searchText.isEmpty {
            search(searchTerm: searchText)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        // Save to recent search text
        if let searchTerm = searchBar.text {
            searchTermViewController?.add(searchTerm: searchTerm)
        }
    }
}

extension ViewController: SearchCoordinatorDelegate {
    func searchCoordinatorDidSelectCancel(_ coordinator: SearchCoordinator) {
        dismiss(animated: true, completion: nil)
    }
}
