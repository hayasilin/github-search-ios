//
//  SpinnerRectView.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import UIKit

class SpinnerRectView: UIView {
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .medium
        spinner.hidesWhenStopped = true
        return spinner
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
        addSubview(spinner)
        spinner.fixInSuperviewCenter()
        spinner.startAnimating()
    }
}
