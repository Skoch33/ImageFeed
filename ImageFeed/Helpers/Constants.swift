//
//  Constants.swift
//  ImageFeed
//
//  Created by Semen Kocherga on 26.05.2023.
//

import Foundation

enum Constants {
    static let accessKey = "td64kmaBVOcrUR8dXMwRFgrS8HypQdQiA6vMYlmE5Io"
    static let secretKey = "U3UPleNeyUnB5mMB56-NFfGHDbB_Xx4yMRVNZezLPWQ"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
