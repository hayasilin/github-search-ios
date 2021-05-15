//
//  NoNetworkView.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import UIKit

protocol NoNetworkViewDelegate: AnyObject {
    func noNetworkViewDidTapRetry(_ noNetworkView: NoNetworkView)
}

class NoNetworkView: UIView {
    weak var delegate: NoNetworkViewDelegate?

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private var detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 208, green: 208, blue: 208)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.layer.borderColor = UIColor(red: 204, green: 204, blue: 204).cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 21.5
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 29, bottom: 12, right: 29)
        return button
    }()

    convenience init(
        title: String,
        detail: String,
        buttonTitle: String
        ) {
        self.init(frame: .zero)

        titleLabel.text = title
        detailLabel.text = detail
        button.setTitle(buttonTitle, for: .normal)
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

        button.addTarget(self, action: #selector(buttonTap(sender:)), for: .touchUpInside)

        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(button)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // spacing
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            button.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 23),

            // height
            button.heightAnchor.constraint(equalToConstant: 43),

            // width
            // note: 1 - (140/640) = 0.78125 from designer
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.78125),
            detailLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.78125),
            ])

        // center
        let guide = UILayoutGuide()
        addLayoutGuide(guide)
        NSLayoutConstraint.activate([
            guide.centerXAnchor.constraint(equalTo: centerXAnchor),
            guide.centerYAnchor.constraint(equalTo: centerYAnchor),

            // vertical
            titleLabel.topAnchor.constraint(equalTo: guide.topAnchor),
            button.bottomAnchor.constraint(equalTo: guide.bottomAnchor),

            // horizontal
            titleLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            detailLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            button.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            ])
    }

    @objc func buttonTap(sender: UIButton) {
        delegate?.noNetworkViewDidTapRetry(self)
    }
}
