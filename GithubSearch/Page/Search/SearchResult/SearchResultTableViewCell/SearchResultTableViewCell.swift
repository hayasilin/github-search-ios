//
//  SearchResultTableViewCell.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var detailLabel: UILabel!

    @IBOutlet var contentProviderLabel: UILabel!

    @IBOutlet var dateLabel: UILabel!

    // Support both
    //  - SearchResultWithImageTableViewCell
    //  - SearchResultNoImageTableViewCell
    @IBOutlet var thumbnailImageView: UIImageView?

    func display(image: UIImage?) {
        thumbnailImageView?.image = image
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView?.image = nil
    }
}
