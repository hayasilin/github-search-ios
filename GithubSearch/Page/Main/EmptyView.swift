//
//  EmptyView.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import UIKit

class EmptyView: UIView {

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()

    convenience init(title: String) {
        self.init(frame: .zero)
        titleLabel.text = title
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureUI()
    }

    func configureUI() {
        backgroundColor = .white

        addSubview(titleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // note: 1 - (140/640) = 0.78125 from designer
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.78125),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
    }
}
