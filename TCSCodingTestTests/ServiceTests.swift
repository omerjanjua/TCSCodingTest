//
//  ServiceTests.swift
//  TCSCodingTestTests
//
//  Created by Omer Janjua on 08/03/2018.
//  Copyright © 2018 Omer Janjua. All rights reserved.
//

import XCTest
@testable import TCSCodingTest

class ServiceTests: XCTestCase {
    fileprivate let service: Servicing = Service()
    
    func testFetchingNowPlayingMovieList() {
        let expectationForNowPlaying = expectation(description: "Now Playing")
        
        service.fetchNowPlayingMovies { (responseDictionary, error) in
            XCTAssert(error == "", "Now playing returned arror")
            XCTAssertNotNil(responseDictionary)
            XCTAssertNotNil(responseDictionary!["results"])
            expectationForNowPlaying.fulfill()
        }
        waitForExpectations(timeout: 1.0) { (_) -> Void in
        }
    }
}
