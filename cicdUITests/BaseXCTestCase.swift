//
//  BaseXCTestCase.swift
//  LeisureDevUITests
//
//  Created by liang.wang on 25/5/2022.
//  Copyright © 2022 CoverMore. All rights reserved.
//

import XCTest

let existsPredicate = NSPredicate(format: "exists == 1")
let globalExpectationTimeout = 15.0

class BaseXCTestCase: XCTestCase {
    var app: XCUIApplication!
    private var launchArguments: [String] = []
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = launchArguments
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }
}

extension BaseXCTestCase {
    // You also can use <#yourElement#>.waitForExistence(timeout: 5)
    func waitFor(_ element: XCUIElement) -> XCUIElement {
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: globalExpectationTimeout, handler: nil)
        return element
    }

    func scrollDown(until element: XCUIElement, maximumSwipes: Int = 50) {
        var swipes = 0
        while !element.visible(), swipes < maximumSwipes {
            app.swipeUp()
            swipes += 1
        }
        _ = waitFor(element)
    }

    func scrollUp(until element: XCUIElement, maximumSwipes: Int = 50) {
        var swipes = 0
        while !element.visible(), swipes < maximumSwipes {
            app.swipeDown()
            swipes += 1
        }
        _ = waitFor(element)
    }

    func tapElementAndWaitForKeyboardToAppear(element: XCUIElement) {
        let keyboard = app.keyboards.element
        while true {
            element.tap()
            if keyboard.exists {
                break
            }
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.5))
        }
    }

    func deleteMyApp() {
        app.terminate()

        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let icon = springboard.icons["Dev Leisure"]
        if icon.exists {
            let iconFrame = icon.frame
            let springboardFrame = springboard.frame
            icon.press(forDuration: 1.3)
            // Tap the little "X" button at approximately where it is. The X is not exposed directly
            springboard.coordinate(withNormalizedOffset: CGVector(dx: (iconFrame.minX + 3) / springboardFrame.maxX, dy: (iconFrame.minY + 3) / springboardFrame.maxY)).tap()
            springboard.alerts.buttons["Delete"].tap()
        }
    }

    func openSafari(with url: URL) -> XCUIApplication {
        let safariApp = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")

        // Start the Safari app as we're starting test from there.
        safariApp.launch()

        // Wait for Safari to be the active application.
        let safariAppActiveExpectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "state == \(XCUIApplication.State.runningForeground.rawValue)"), object: safariApp)
        wait(for: [safariAppActiveExpectation], timeout: 10)

        // Tap the domain search field and enter the url.
        let urlBar = safariApp.otherElements["URL"]
        XCTAssert(urlBar.waitForExistence(timeout: 3.0), "The URL Bar should exist after opening Safari.")
        urlBar.tap()

        let urlTextField = safariApp.textFields["URL"]
        XCTAssert(urlTextField.waitForExistence(timeout: 3), "Even with large pages with expect the urlTextField to be available after 3 seconds")
        urlTextField.typeText(url.absoluteString)
        safariApp.keyboards.firstMatch.buttons["Go"].tap()

        return safariApp
    }

    // Used to permission allow alert, etc
    func handleSystemAlert(description: String = "Location Services", dismissButtonText: String = "Allow") {
        addUIInterruptionMonitor(withDescription: description) { (alert) -> Bool in
            alert.buttons[dismissButtonText].tap()
            return true
        }
    }
}
