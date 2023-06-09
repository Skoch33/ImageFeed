//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Semen Kocherga on 2.06.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    
//MARK: - UIStatusBarStyle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
//MARK: - Private Properties
    
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()

//MARK: - LifeCycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if OAuth2TokenStorage.token != nil
        {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
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

//MARK: - SplashViewController

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { assert(false)
                assertionFailure("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)")
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

//MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }

    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let authToken):

                OAuth2TokenStorage.token = authToken
                self.switchToTabBarController()
            case .failure:
                // TODO:
                break
            }
        }
    }
}


