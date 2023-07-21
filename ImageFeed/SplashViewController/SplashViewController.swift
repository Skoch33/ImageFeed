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
    private let imagesListService = ImagesListService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (oauth2TokenStorage.token != nil) {
            guard let token = oauth2TokenStorage.token else { return }
            fetchProfile(token: token)
        } else {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let authViewController = storyBoard.instantiateViewController(withIdentifier: "AuthViewController")
                    as? AuthViewController else {return}
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        splashScreenInit(view: view)
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
                self.oauth2TokenStorage.token = token
                self.fetchProfile(token: token)
            case .failure (let error):
                self.showAlert(with: error)
                self.oauth2TokenStorage.token = nil
                break
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success (let profile):
                self.fetchProfileImage(username: profile.username)
                self.switchToTabBarController()
            case .failure (let error):
                self.showAlert(with: error)
                break
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func fetchProfileImage(username: String) {
        ProfileImageService.shared.fetchProfileImageURL(username: username) { result in
            
            switch result {
            case .success(let url):
                print("IMG avatar url = \(url)")
                break
            case .failure(let error):
                print("IMG Error loading. Error: \(error)")
                break
            }
        }
    }
}

// MARK: - Alert

extension SplashViewController {
    private func showAlert(with error: Error) {
        let alert = UIAlertController(title: "Что-то пошло не так", message: "Не удалось войти в систему", preferredStyle: .alert)
        let uiAlertAction = UIAlertAction(title: "Ok", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(uiAlertAction)
        self.present(alert, animated: true)
    }
}


