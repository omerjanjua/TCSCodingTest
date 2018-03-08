//
//  TCSCodingTestUITests.swift
//  TCSCodingTestUITests
//
//  Created by Omer Janjua on 07/03/2018.
//  Copyright © 2018 Omer Janjua. All rights reserved.
//

import XCTest

class TCSCodingTestUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testMovieDetailScreen() {
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"The Shape of Water").element.tap()
        XCTAssertEqual(app.staticTexts["The Shape of Water"].exists, true)
    }
    
    func testCollectionDetailScreen() {
        let cellsQuery = XCUIApplication().collectionViews.cells
        cellsQuery.otherElements.containing(.staticText, identifier:"Thor: Ragnarok").element.tap()
        cellsQuery.otherElements.containing(.staticText, identifier:"Thor").element.tap()
        XCTAssertEqual(app.staticTexts["Thor Collection"].exists, false)
    }
    
    func testAppNavigationBackFromDetail() {
        let app = XCUIApplication()
        let firstChild = app.collectionViews.children(matching:.any).element(boundBy: 0)
        if firstChild.exists {
            firstChild.tap()
        }
        
        if app.navigationBars["TCSCodingTest.MovieDetailsView"].exists {
            let nowPlayingMoviesButton = app.navigationBars["TCSCodingTest.MovieDetailsView"].buttons["Now Playing Movies"]
            nowPlayingMoviesButton.tap()
        }
        else {
            let nowPlayingMoviesButton = app.navigationBars["The Shape of Water"].buttons["Now Playing Movies"]
            nowPlayingMoviesButton.tap()
        }
        
        let trackInfoLabel = app.staticTexts["Other"]
        XCTAssertEqual(trackInfoLabel.exists, false)
        
        let titleLabel = app.staticTexts["Now Playing Movies"]
        XCTAssertEqual(titleLabel.exists, false)
    }
}
