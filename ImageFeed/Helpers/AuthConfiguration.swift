//
//  Constants.swift
//  ImageFeed
//
//  Created by Semen Kocherga on 26.05.2023.
//

import Foundation

struct Constants {
    static let accessKey = "veRRna9WbEMlROnNdL1-YQg32NWCwpPhkXW9q4tqYkg"
    static let secretKey = "9nuv808RI2aYvErYkwmMKZBK_-_ih37HsxDI36pned0"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let baseURL =  URL(string: "https://unsplash.com")!
    static let code = "code"
    static let authorizationPath = "/oauth/authorize/native"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    let code: String
    let authorizationPath: String
    let baseURL: URL
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 defaultBaseURL: Constants.defaultBaseURL,
                                 authURLString: Constants.unsplashAuthorizeURLString,
                                 
                                 code: Constants.code,
                                 authorizationPath: Constants.authorizationPath,
                                 baseURL: Constants.baseURL)
    }
}
