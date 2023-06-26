//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Semen Kocherga on 15.05.2023.
//

import UIKit
import Kingfisher

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
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private var profileImageView: UIImageView?
    private let storageToken = OAuth2TokenStorage()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImageViewCall()
        nameLabelCall()
        loginNameLabelCall()
        descriptionLabelCall()
        logoutButtonCall()
        updateProfileDetails()
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: profileImageService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.downloadAndSetAvatar()
        }
        downloadAndSetAvatar()
    }
    
    //MARK: - Privat Functions
    
    private func downloadAndSetAvatar() {
        guard let avatarURL = profileImageService.avatarURL else { return }
        DispatchQueue.main.async {
            self.avatarImageView.kf.indicatorType = .activity
            self.avatarImageView.kf.setImage(with: avatarURL)
        }
    }
    
    private func updateProfileDetails() {
        guard let profile = profileService.currentProfile else { return }
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func avatarImageViewCall() {
        view.backgroundColor = UIColor(named: "YP Black (iOS)")
        let avatarImageView = UIImageView(image: UIImage(named: "avatar"))
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        self.avatarImageView = avatarImageView
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.layer.masksToBounds = true
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
        showLogoutAlert()
    }
    
    private func logout() {
        storageToken.clearToken()
        WebViewViewController.clean()
        cleanServicesData()
        tabBarController?.dismiss(animated: true)
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration") }
        window.rootViewController = SplashViewController()
    }
    
    private func showLogoutAlert() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            self.logout()
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func cleanServicesData() {
        ImagesListService.shared.clean()
        ProfileService.shared.clean()
        ProfileImageService.shared.clean()
    }
}
