//
//  SearchTermTableViewCell.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import UIKit

class SearchTermTableViewCell: UITableViewCell {
    lazy var title: UILabel = {
        let title = UILabel(frame: .zero)
        title.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 14)
        return title
    }()

    var deleteButtonDidTap: (() -> Void)?
    lazy var deleteButton: UIButton = {
        let deleteButton = ExtraTouchAreaButton(frame: .zero)
        deleteButton.extraTouchAreaInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        deleteButton.setImage(UIImage(named: "icDelete"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.accessibilityIdentifier = UITestIdentifierConfig.searchTermDeleteButton.rawValue
        return deleteButton
    }()

    @objc func deleteButtonTapped() {
        deleteButtonDidTap?()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        backgroundColor = .white

        selectionStyle = .none

        addSubview(title)
        addSubview(deleteButton)

        title.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18),
            title.rightAnchor.constraint(equalTo: self.deleteButton.rightAnchor, constant: -24),
            title.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])

        NSLayoutConstraint.activate([
            deleteButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18),
            deleteButton.centerYAnchor.constraint(equalTo: self.title.centerYAnchor),
        ])
    }
}
