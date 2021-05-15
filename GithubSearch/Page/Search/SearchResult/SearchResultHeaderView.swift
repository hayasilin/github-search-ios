//
//  SearchResultHeaderView.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import UIKit

protocol SearchResultHeaderViewDelegate: AnyObject {
    func searchResultHeaderView(
        _ headerView: SearchResultHeaderView,
        didSelectSortType sortType: SearchSortType
    )
}

class SearchResultHeaderView: UITableViewHeaderFooterView {
    weak var delegate: SearchResultHeaderViewDelegate?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        viewCommonSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewCommonSetup()
    }

    func setupView(sortType: SearchSortType) {
        switch sortType {
        case .mostRelated:
            mostRelated.isSelected = true
            latest.isSelected = false
        case .latest:
            mostRelated.isSelected = false
            latest.isSelected = true
        }

        setupFont(button: mostRelated)
        setupFont(button: latest)
    }

    private func setupFont(button: UIButton) {
        button.titleLabel?.font = button.isSelected
            ? UIFont.boldSystemFont(ofSize: 13)
            : UIFont.systemFont(ofSize: 13)
    }

    private lazy var mostRelated: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Stars", for: .normal)
        btn.setTitleColor(buttonNormalColor, for: .normal)
        btn.setTitleColor(buttonSelectedColor, for: .selected)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(mostRelatedButtonTapped(_:)), for: .touchUpInside)
        return btn
    }()

    private lazy var latest: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Updated", for: .normal)
        btn.setTitleColor(buttonNormalColor, for: .normal)
        btn.setTitleColor(buttonSelectedColor, for: .selected)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(latestButtonTapped(_:)), for: .touchUpInside)
        return btn
    }()

    private var buttonNormalColor: UIColor {
        return UIColor(red: 181, green: 181, blue: 181)
    }

    private var buttonSelectedColor: UIColor {
        return .black
    }

    @objc private func mostRelatedButtonTapped(_ sender: UIButton) {
        delegate?.searchResultHeaderView(self, didSelectSortType: .mostRelated)
    }

    @objc private func latestButtonTapped(_ sender: UIButton) {
        delegate?.searchResultHeaderView(self, didSelectSortType: .latest)
    }

    /// mostRelated - divider - latest
    private func viewCommonSetup() {
        contentView.backgroundColor = .white

        let divider = UIView()
        divider.backgroundColor = UIColor(red: 229, green: 229, blue: 229)

        contentView.addSubview(mostRelated)
        contentView.addSubview(divider)
        contentView.addSubview(latest)

        mostRelated.translatesAutoresizingMaskIntoConstraints = false
        divider.translatesAutoresizingMaskIntoConstraints = false
        latest.translatesAutoresizingMaskIntoConstraints = false

        mostRelated.setContentHuggingPriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            // divider sizing
            divider.widthAnchor.constraint(equalToConstant: 1),
            divider.heightAnchor.constraint(equalToConstant: 9),

            // vertical spacing
            mostRelated.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 4),
            divider.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 4),
            latest.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 4),

            // horizontal spacing
            mostRelated.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 18),
            latest.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: 18),

            // horizontal divider spacing
            divider.leftAnchor.constraint(equalTo: mostRelated.rightAnchor, constant: 8),
            divider.rightAnchor.constraint(equalTo: latest.leftAnchor, constant: -8),
        ])
    }
}
