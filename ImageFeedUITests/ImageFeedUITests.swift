//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Semen Kocherga on 18.07.2023.
//

import XCTest

import XCTest

class Image_FeedUITests: XCTestCase {
    
    private let login = ""
    private let password = ""
    private let userName = ""
    private let nickname = "@"
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        print(app.debugDescription)
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.textFields.element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText(login)
        print(app.debugDescription)
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        passwordTextField.tap()
        passwordTextField.typeText(password)
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)

        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }
    
    func testFeed() throws {
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        cellToLike.buttons["likeButton"].tap()
        XCTAssertTrue(cellToLike.waitForExistence(timeout: 5))
        cellToLike.buttons["likeButton"].tap()
        sleep(3)
        cellToLike.tap()
        sleep(3)
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["backButton"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["\(userName)"].exists)
        XCTAssertTrue(app.staticTexts["\(nickname)"].exists)
        
        app.buttons["logoutButton"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(2)
        
        let authButton = app.buttons["Authenticate"]
        XCTAssertTrue(authButton.waitForExistence(timeout: 5))
    }
}
