//
//  SearchTermHeaderView.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import UIKit

class SearchTermHeaderView: UIView {
    lazy var title: UILabel = {
        let title = UILabel(frame: .zero)
        title.textColor = UIColor(red: 199, green: 199, blue: 199)
        title.font = UIFont.systemFont(ofSize: 13)
        return title
    }()

    var actionButtonDidTap: (() -> Void)?
    lazy var actionButton: UIButton = {
        let actionButton = UIButton(frame: .zero)
        actionButton.setTitleColor(UIColor(red: 131, green: 131, blue: 131), for: .normal)
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return actionButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        backgroundColor = .white

        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 4),
            title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18),
        ])

        addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actionButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18),
            actionButton.centerYAnchor.constraint(equalTo: title.centerYAnchor),
        ])
    }

    @objc func actionButtonTapped() {
        actionButtonDidTap?()
    }
}
