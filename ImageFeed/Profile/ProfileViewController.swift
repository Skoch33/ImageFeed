//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Semen Kocherga on 15.05.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var loginNameLabel: UILabel!
    @IBOutlet var discriptionLabel: UILabel!
    @IBOutlet var logOutButton: UIButton!
    
    @IBAction func didTapLogOutButton() {
    }
}
