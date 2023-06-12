//
//  Constants.swift
//  ImageFeed
//
//  Created by Semen Kocherga on 26.05.2023.
//

import Foundation

enum Constants {
    static let accessKey = "veRRna9WbEMlROnNdL1-YQg32NWCwpPhkXW9q4tqYkg"
    static let secretKey = "9nuv808RI2aYvErYkwmMKZBK_-_ih37HsxDI36pned0"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
