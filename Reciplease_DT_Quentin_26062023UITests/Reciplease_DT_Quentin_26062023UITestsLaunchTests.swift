//
//  Reciplease_DT_Quentin_26062023UITestsLaunchTests.swift
//  Reciplease_DT_Quentin_26062023UITests
//
//  Created by Quentin Dubut-Touroul on 26/06/2023.
//

import XCTest

final class Reciplease_DT_Quentin_26062023UITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
