//
//  XCUIElement + Extensions.swift
//  LeisureDevUITests
//
//  Created by liang.wang on 25/5/2022.
//  Copyright © 2022 CoverMore. All rights reserved.
//

import XCTest

// MARK: actions

extension XCUIElement {
    func scrollDownToElement(element: XCUIElement) {
        while !element.visible() {
            swipeUp()
        }
    }

    func scrollUpToElement(element: XCUIElement) {
        while !element.visible() {
            swipeDown()
        }
    }

    func clearText() -> Self {
        if let val = value as? String {
            var del = ""
            for _ in 0 ..< val.count {
                del += "\u{8}"
            }
            typeText(del)
        }
        return self
    }

    func focus() -> Self {
        tap()
        return self
    }

    func clearText() {
        guard let stringValue = value as? String else {
            return
        }

        var deleteString = String()
        for _ in stringValue {
            deleteString += XCUIKeyboardKey.delete.rawValue
        }
        typeText(deleteString)
    }

    func clearAndEnterText(text: String) {
        guard let stringValue = value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }

        tap()

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)

        typeText(deleteString)
        typeText(text)
    }
}

// MARK: properties

extension XCUIElement {
    var didAppear: Bool { waitForExistence(timeout: 1) && !frame.isEmpty }

    var text: String { value as! String }
    var isChecked: Bool { value as! Bool }

    var hasFocus: Bool {
        let hasKeyboardFocus = (value(forKey: "hasKeyboardFocus") as? Bool) ?? false
        return hasKeyboardFocus
    }

    func visible() -> Bool {
        guard exists, !frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(frame)
    }
}

// MARK: coordinate

extension XCUIElement {
    func tap(location: CGPoint) {
        coordinate(from: location).tap()
    }

    func coordinate(from point: CGPoint) -> XCUICoordinate {
        return coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0)).withOffset(CGVector(dx: point.x, dy: point.y))
    }
}
