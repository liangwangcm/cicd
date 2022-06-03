//
//  cicdUITests.swift
//  cicdUITests
//
//  Created by liang.wang on 16/5/2022.
//

import XCTest

class cicdUITests: BaseXCTestCase {
    
    private var launchArguments: [String] = ["--Reset"]
    
    func testGmailLogin() throws {
        openDeepLinkInGmail(useValidDeepLink: false)
    }

    func openDeepLinkInGmail(useValidDeepLink: Bool) {
        clearSafariData()
        
        let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")

        safari.launch()
        let _ = safari.wait(for: .runningForeground, timeout: 10)
        
        safari.textFields["Address"].tap()
        safari.textFields["Address"].typeText("https://mail.google.com")
        safari.keyboards.buttons["Go"].tap()
        
        let emailTextField = waitFor(safari.webViews.textFields["Email or phone"])
        emailTextField.tap()
        sleep(1)
        emailTextField.typeText("cmmagiclinktest@gmail.com")
        safari.keyboards.buttons["Return"].tap()
        
        let passwordTextField = waitFor(safari.webViews.secureTextFields["Enter your password"])
        passwordTextField.tap()
        sleep(1)
        passwordTextField.typeText("Test@123")
        safari.keyboards.buttons["go"].tap()
        
        let notInterested = waitFor(safari.webViews.staticTexts["I am not interested"])
        notInterested.tap()
        
        // Now we are in gmail home page
        
//        let firstUnreadMail = waitFor(safari.webViews.buttons["Unread. travelon@travelexinsuran. Travelex One-Time Login"].firstMatch)
//        firstUnreadMail.tap()
        
        let firstReadMail = waitFor(safari.webViews.buttons["travelon@travelexinsuran. Travelex One-Time Login"].firstMatch)
        firstReadMail.tap()
        
        
        let deepLinkButton = waitFor(safari.webViews.staticTexts["Login"])
        deepLinkButton.tap()
        
//        app.activate() // go back to app

    }

    func clearSafariData() {
      let settingsApp = XCUIApplication(bundleIdentifier: "com.apple.Preferences")
      settingsApp.terminate() // this is to make sure it's reset
      settingsApp.launch()
      settingsApp.cells["Safari"].tap()
      
      settingsApp.tables.staticTexts["CLEAR_HISTORY_AND_DATA"].tap()
      settingsApp.sheets["Clearing will remove history, cookies, and other browsing data."].scrollViews.otherElements.buttons["Clear History and Data"].tap()
        
      settingsApp.terminate()
    }
}
