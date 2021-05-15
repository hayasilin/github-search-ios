//
//  SearchResultTableViewCell.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import UIKit
import SDWebImage

class SearchResultTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var detailLabel: UILabel!

    @IBOutlet var contentProviderLabel: UILabel!

    @IBOutlet var dateLabel: UILabel!

    // Support both
    //  - SearchResultWithImageTableViewCell
    //  - SearchResultNoImageTableViewCell
    @IBOutlet var thumbnailImageView: UIImageView?

    func setupImage(with url: URL?) {
        thumbnailImageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "no_image"))
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView?.sd_setImage(with: nil, placeholderImage: UIImage(named: "no_image"))
    }
}
