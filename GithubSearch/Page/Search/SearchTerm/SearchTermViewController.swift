//
//  SearchTermViewController.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import UIKit

class SearchTermViewController: UIViewController, EmptyDisplayable {
    lazy var viewModel = SearchTermViewModel()

    var emptyView: EmptyView?

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 7, right: 0)
        tableView.registerReusableCellClass(SearchTermTableViewCell.self)
        tableView.accessibilityIdentifier = UITestIdentifierConfig.searchTermTableView.rawValue
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        view.addSubview(tableView)
        tableView.pinEdgesToSuperviewEdges()

        viewModel.recentSearchTermListDidChange = { [weak self] in
            guard let `self` = self else {
                return
            }
            DispatchQueue.main.async {
                if self.viewModel.isEmpty() {
                    self.showEmptyView(withText: "No recent Github keyword. Try search any Github keyword")
                } else {
                    self.removeEmptyView()
                }
                self.tableView.reloadData()
            }
        }
        viewModel.loadRecentSearchTermList()
    }

    var userDidClick: ((_ seachTerm: String) -> Void)?

    func add(searchTerm: String) {
        viewModel.add(recentSearchTerm: searchTerm)
    }
}

extension SearchTermViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchTermTableViewCell = tableView.shortDequeueCell(for: indexPath)
        guard let searchTerm = viewModel.getSearchTerm(with: indexPath) else {
            return cell
        }
        cell.title.text = searchTerm
        cell.deleteButtonDidTap = {
            self.viewModel.delete(recentSearchTerm: searchTerm)
        }
        return cell
    }
}

extension SearchTermViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let clickedSearchTerm = viewModel.getSearchTerm(with: indexPath) else {
            return
        }
        userDidClick?(clickedSearchTerm)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SearchTermHeaderView()
        headerView.title.text = "Recent search"
        headerView.actionButton.setTitle("Delete all", for: .normal)
        headerView.actionButtonDidTap = {
            self.viewModel.deleteAllRecentSearchTerms()
        }
        return headerView
    }
}
