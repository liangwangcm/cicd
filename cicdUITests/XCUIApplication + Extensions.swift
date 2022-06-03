//
//  XCUIApplication + Extensions.swift
//  LeisureDevUITests
//
//  Created by liang.wang on 25/5/2022.
//  Copyright © 2022 CoverMore. All rights reserved.
//

import XCTest

extension XCUIApplication {
    func tableCell(withText text: String) -> XCUIElement {
        return tables.cells.staticTexts[text]
    }

    func cellByIndex(table: XCUIElement, index: Int) -> XCUIElement {
        return table.cells.element(boundBy: index)
    }

    func cellByLabel(table: XCUIElement, label: String) -> XCUIElement {
        return table
            .children(matching: .cell)
            .element(boundBy: 0)
            .staticTexts[label]
            .firstMatch
    }

    func countCellsInTable(table: XCUIElement) -> Int {
        table.swipeUp() // Fix: Ensure all cells are dequeued before getting the count
        table.swipeDown()
        return simpleCountCellsInTable(table: table)
    }

    func simpleCountCellsInTable(table: XCUIElement) -> Int {
        return table.cells.count
    }
}
