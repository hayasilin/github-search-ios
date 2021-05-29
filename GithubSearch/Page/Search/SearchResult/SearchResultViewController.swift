//
//  SearchResultViewController.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func viewControllerDidSelectRepository(_ vc: SearchResultViewController, repositoryLink link: URL)
}

class SearchResultViewController: UIViewController, LoadingIndicatorDisplayable {
    init(viewModel: SearchResultViewModel, delegate: SearchResultViewControllerDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.delegate = delegate
    }

    fileprivate enum Constants {
        static let noImageCell = "SearchResultNoImageTableViewCell"
        static let imageCell = "SearchResultWithImageTableViewCell"
        static let header = "header"
    }

    weak var delegate: SearchResultViewControllerDelegate?

    lazy var viewModel = SearchResultViewModel()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
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
        tableView.registerReusableHeaderFooterViewClass(
            SearchResultHeaderView.self,
            withIdentifier: Constants.header
        )
        tableView.accessibilityIdentifier = UITestIdentifierConfig.searchResultTableView.rawValue
        return tableView
    }()

    // NoNetworkDisplayable
    var noNetworkView: NoNetworkView?

    // LoadingIndicatorDisplayable
    var spinner: UIActivityIndicatorView?

    // EmptyDisplayable
    var emptyView: EmptyView?

    private let queue = OperationQueue()
    private var operations: [IndexPath: Operation] = [:]

    private let imageCache = NSCache<NSURL, UIImage>()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        view.addSubview(tableView)
        tableView.pinEdgesToSuperviewEdges()

        binding()

        viewModel.request()

        showLoadingIndicator()
    }

    private func binding() {
        viewModel.searchResultRepositoryListDidChange = { [weak self] in
            DispatchQueue.main.async {
                self?.removeLoadingIndicator()
                self?.tableView.reloadData()
            }
        }
    }

    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
}

extension SearchResultViewController: UITableViewDataSource {
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

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard viewModel.shouldShowHeader(inSection: section) else { return nil }

        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: Constants.header
        ) as? SearchResultHeaderView
        headerView?.delegate = self
        headerView?.setupView(sortType: viewModel.sortType)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.shouldShowHeader(inSection: section) ? 48 : 0
    }
}

extension SearchResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let url = viewModel.repositoryURL(at: indexPath) {
            delegate?.viewControllerDidSelectRepository(self, repositoryLink: url)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.willDisplay(indexPath: indexPath)
    }
}

extension SearchResultViewController: SearchResultHeaderViewDelegate {
    func searchResultHeaderView(
        _ headerView: SearchResultHeaderView,
        didSelectSortType sortType: SearchSortType
    ) {
        viewModel.sortType = sortType
    }
}

extension SearchResultViewController: NoNetworkDisplayable, NoNetworkViewDelegate {
    func noNetworkViewDidTapRetry(_ noNetworkView: NoNetworkView) {
        viewModel.request()
    }
}

extension SearchResultViewController {
    func showLoadMoreSpinner() {
        if tableView.tableFooterView == nil {
            let footer = SpinnerRectView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 44))
            footer.backgroundColor = .white
            tableView.tableFooterView = footer
        }
        (tableView.tableFooterView as? SpinnerRectView)?.spinner.startAnimating()
    }

    func removeLoadMoreSpinner() {
        (tableView.tableFooterView as? SpinnerRectView)?.spinner.stopAnimating()
    }
}
