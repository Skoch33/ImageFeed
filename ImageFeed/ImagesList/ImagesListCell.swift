//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Semen Kocherga on 2.05.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet var CellImage: UIImageView!
    @IBOutlet var LikeButton: UIButton!
    @IBOutlet var DateLabel: UILabel!
}


