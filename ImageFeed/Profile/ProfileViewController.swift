//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Semen Kocherga on 15.05.2023.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol { get set }
    var imageView: UIImageView { get set }
    var nameLabel: UILabel { get set }
    var nicknameLabel: UILabel { get set }
    var textLabel: UILabel { get set }
    func updateAvatar()
    func configureViews()
    func configureConstraints()
    func showLogoutAlert()
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {

    lazy var presenter: ProfilePresenterProtocol = {
        return ProfilePresenter()
    }()

    lazy var profileImage = UIImage(named: "Novikova_Profile")
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView(image: profileImage)
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var nameLabel : UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.textColor = .ypWhite
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    lazy var nicknameLabel : UILabel = {
        let nicknameLabel = UILabel()
        nicknameLabel.text = "@ekaterina_nov"
        nicknameLabel.font = UIFont.systemFont(ofSize: 13)
        nicknameLabel.textColor = .ypGrey
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nicknameLabel
    }()
    
    lazy var textLabel : UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Hello, world!"
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.textColor = .ypWhite
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    private lazy var button : UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(self.didTapButton))
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "logoutButton"
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
        presenter.view = self
        presenter.viewDidLoad()
        updateAvatar()
    }
    
    func configureViews() {
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(nicknameLabel)
        view.addSubview(textLabel)
        view.addSubview(button)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nicknameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            textLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            textLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
        ])
        
    }
    @objc
    private func didTapButton() {
        showLogoutAlert()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - Extensions

extension ProfileViewController {

    func updateAvatar() {
        view.backgroundColor = .ypBlack
        guard let url = presenter.getUrlForProfileImage() else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: imageView.frame.width)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url,
                              placeholder: UIImage(named: "avatar"),
                              options: [.processor(processor),.cacheSerializer(FormatIndicatedCacheSerializer.png)])
        let cache = ImageCache.default
        cache.clearDiskCache()
        cache.clearMemoryCache()
    }
    
    func showLogoutAlert() {
        let alert = presenter.makeAlert()
        present(alert, animated: true, completion: nil)
    }
}
