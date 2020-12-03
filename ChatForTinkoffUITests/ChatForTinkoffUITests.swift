//
//  ChatForTinkoffUITests.swift
//  ChatForTinkoffUITests
//
//  Created by Александра Колесова on 01.12.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import XCTest

class ChatForTinkoffUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let button = app.navigationBars.buttons["Profile Button Identifier"].firstMatch
        let profileButtonExt = button.waitForExistence(timeout: 5)
        
        XCTAssertTrue(profileButtonExt)
        button.tap()
        
        let editButton = app.buttons["Edit Button"].firstMatch
        let editButtonExt = editButton.waitForExistence(timeout: 5)
        
        XCTAssertTrue(editButtonExt)
        editButton.tap()
        
        let nameTextfield = app.textFields["Name TextField"].firstMatch
        let aboutTextfield = app.textFields["About TextField"].firstMatch
        
        let nameTextfieldExt = nameTextfield.waitForExistence(timeout: 5)
        let aboutTextfieldExt = aboutTextfield.waitForExistence(timeout: 5)
        
        XCTAssertTrue(nameTextfieldExt)
        XCTAssertTrue(aboutTextfieldExt)

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
