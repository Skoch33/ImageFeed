//
//  ProfileTest.swift
//  ImageFeedTests
//
//  Created by Semen Kocherga on 17.07.2023.
//

@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // given
        let profileService = ProfileService()
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy(profileService: profileService)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testGetUrlForProfileImage() {
        //given
        let profileService = ProfileService()
        let presenter = ProfilePresenterSpy(profileService: profileService)
        
        //when
        let url = presenter.getUrlForProfileImage()?.absoluteString
        
        //then
        XCTAssertEqual(url, "\(Constants.baseURL)")
    }
    
    func testExitFromProfile() {
        //given
        let profileService = ProfileService()
        let presenter = ProfilePresenterSpy(profileService: profileService)
        let view = ProfileViewControllerSpy(presenter: presenter)
        view.presenter = presenter
        presenter.view = view
        
        //when
        view.showAlert()
        
        //then
        XCTAssertTrue(presenter.didLogoutCalled)
    }
    
    func testLoadProfileInfo() {
        //given
        let profileService = ProfileService()
        let presenter = ProfilePresenterSpy(profileService: profileService)
        let view = ProfileViewControllerSpy(presenter: presenter)
        view.presenter = presenter
        presenter.view = view
        
        //when
        presenter.updateProfileDetails(profile: profileService.currentProfile)
        
        //then
        XCTAssertTrue(view.views)
        XCTAssertTrue(view.constraints)
    }
}
