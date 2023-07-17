//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Semen Kocherga on 17.07.2023.
//

@testable import ImageFeed
import UIKit

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
    }
    
    func setProgressHidden(_ isHidden: Bool) {
    }
}
