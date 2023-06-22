//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Semen Kocherga on 2.06.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
//MARK: - UIStatusBarStyle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
//MARK: - Private Properties
    
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared

    //MARK: - Privat Functions
    
    private func splashScreenInit(view: UIView){
        view.backgroundColor = UIColor(named: "YP Black (iOS)")
        let screenImage = UIImage(named: "Vector") ?? UIImage(named: "Vector")
        let screenImageView = UIImageView(image: screenImage)
        view.addSubview(screenImageView)
        screenImageView.translatesAutoresizingMaskIntoConstraints = false
        screenImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        screenImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        screenImageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        screenImageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splashScreenInit(view: view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = OAuth2TokenStorage.token {
            UIBlockingProgressHUD.show()
            profileService.fetchProfile(token) { [weak self] _ in
                guard let self else { return }
                self.profileImageService.fetchProfileImageURL(
                    token: token,
                    username: self.profileService.currentProfile!.username
                ) { _ in
                    self.switchToTabBarController()
                    UIBlockingProgressHUD.dismiss()
                }
            }
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let authViewController = storyboard.instantiateViewController(identifier: "AuthViewController") as? AuthViewController else { return }
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

// MARK: - Functions
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assert(false)
            assertionFailure("Invalid Configuration")
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

//MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        ProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }

    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                OAuth2TokenStorage.token = token
                self.profileService.fetchProfile(token) { _ in
                    self.switchToTabBarController()
                    UIBlockingProgressHUD.dismiss()
                }
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlert()
            }
        }
    }
}

// MARK: - Alert

extension SplashViewController {
    func showAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так", message: "Не удалось войти в систему", preferredStyle: .alert)
        let uiAlertAction = UIAlertAction(title: "Ok", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(uiAlertAction)
        present(alert, animated: true)
    }
}


