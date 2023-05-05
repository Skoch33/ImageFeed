//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Semen Kocherga on 2.05.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
}


