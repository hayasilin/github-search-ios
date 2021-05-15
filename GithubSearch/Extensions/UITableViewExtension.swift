//
//  UITableViewExtension.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation
import UIKit

extension UITableView {
    @discardableResult
    func registerReusableCellNib<T: UITableViewCell>(
        _ cellClass: T.Type,
        withIdentifier identifier: String = T.reuseIdentifier
        ) -> UITableView {
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
        return self
    }

    @discardableResult
    func registerReusableCellClass<T: UITableViewCell>(
        _ cellClass: T.Type,
        withIdentifier identifier: String = T.reuseIdentifier
        ) -> UITableView {
        register(cellClass, forCellReuseIdentifier: identifier)
        return self
    }

    func shortDequeueCell<T: UITableViewCell>(
        withIdentifier identifier: String = T.reuseIdentifier,
        for indexPath: IndexPath
        ) -> T {
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T ?? T()
    }

    @discardableResult
    func registerReusableHeaderFooterViewNib<T: UITableViewHeaderFooterView>(
        _ headerFooterViewClass: T.Type,
        withIdentifier identifier: String = T.reuseIdentifier
        ) -> UITableView {
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: identifier)
        return self
    }

    @discardableResult
    func registerReusableHeaderFooterViewClass<T: UITableViewHeaderFooterView>(
        _ headerFooterViewClass: T.Type,
        withIdentifier identifier: String = T.reuseIdentifier
        ) -> UITableView {
        register(headerFooterViewClass, forHeaderFooterViewReuseIdentifier: identifier)
        return self
    }

    func shortDequeueHeaderFooterView<T: UITableViewHeaderFooterView>(
        _ headerFooterViewClass: T.Type,
        withIdentifier identifier: String = T.reuseIdentifier
        ) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T ?? T()
    }
}
