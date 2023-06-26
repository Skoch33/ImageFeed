//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Semen Kocherga on 2.06.2023.
//

import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    static private let bearerTokenKey = "imageFeedBearerToken"
    static var token: String? {
        get {
            let token: String? = KeychainWrapper.standard.string(forKey: OAuth2TokenStorage.bearerTokenKey)
            return token
        }
        set {
            KeychainWrapper.standard.set(newValue!, forKey: OAuth2TokenStorage.bearerTokenKey)
        }
    }
}
