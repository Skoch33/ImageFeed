//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Semen Kocherga on 15.05.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    //MARK: - UIStatusBarStyle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Properties
    
    private var avatarImageView: UIImageView!
    private var nameLabel: UILabel!
    private var loginNameLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var logoutButton: UIButton!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImageViewCall()
        nameLabelCall()
        loginNameLabelCall()
        descriptionLabelCall()
        logoutButtonCall()
        
    }
    
    //MARK: - Privat Functions
    
    private func avatarImageViewCall() {
        let avatarImageView = UIImageView(image: UIImage(named: "avatar"))
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        self.avatarImageView = avatarImageView
    }
    
    private func nameLabelCall() {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        nameLabel.textColor = UIColor(named: "YP White (iOS)")
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        nameLabel.text = "Екатерина Новикова"
        
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        
        self.nameLabel = nameLabel
    }
    
    private func loginNameLabelCall() {
        let loginNameLabel = UILabel()
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        
        loginNameLabel.textColor = UIColor(named: "YP Gray (iOS)")
        loginNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        loginNameLabel.text = "@ekaterina_nov"
        
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        loginNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        
        self.loginNameLabel = loginNameLabel
    }
    
    private func descriptionLabelCall() {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        descriptionLabel.textColor = UIColor(named: "YP White (iOS)")
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.text = "Hello, world!"
        
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        
        self.descriptionLabel = descriptionLabel
    }
    
    private func logoutButtonCall() {
        let logoutButton = UIButton.systemButton(with: UIImage(named: "logout_button")!, target: self, action: #selector(Self.didTapLogoutButton))
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        logoutButton.tintColor = UIColor(named: "YP Red (iOS)")
        
        logoutButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        
        self.logoutButton = logoutButton
    }
    
    @objc
    private func didTapLogoutButton() {
        
    }
}
