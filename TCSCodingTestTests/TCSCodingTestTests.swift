//
//  TCSCodingTestTests.swift
//  TCSCodingTestTests
//
//  Created by Omer Janjua on 07/03/2018.
//  Copyright © 2018 Omer Janjua. All rights reserved.
//

import XCTest
@testable import TCSCodingTest

class TCSCodingTestTests: XCTestCase {
    let service: Servicing = ServiceMock()

    func testFetchNowplayingMovie() {
        let expectationForNowPlaying = expectation(description: "waitingForNowPlaying")
        let viewModel:NowPlayingViewModel? = NowPlayingViewModel(service: service) {_,_ in
            expectationForNowPlaying.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { (_) -> Void in
            XCTAssert((viewModel?.movies.count)! > 0, "Data not returned correctly")
        }
    }
}

class ServiceMock: Servicing {
    var errorMessage = ""
    
    func fetchNowPlayingMovies (completion : @escaping (responseDictionary?, String) -> ()){
        
        let responseData: Data? = readJson(file: "NowPlaying")
        
        let responseDictionary = self.processResponse(responseData!)
        
        DispatchQueue.main.async {
            completion(responseDictionary,self.errorMessage)
        }
    }
    func fetchMovieDetails (movieID:Int, completion : @escaping (responseDictionary?, String) -> ()){
        let responseData: Data? = readJson(file: "MovieDetail")
        
        let responseDictionary = self.processResponse(responseData!)
        
        DispatchQueue.main.async {
            completion(responseDictionary,self.errorMessage)
        }
    }
    
    func fetchMovieCollection (collectionID:Int, completion : @escaping (responseDictionary?, String) -> ()) {
        let responseData: Data? = readJson(file: "MovieCollection")
        
        let responseDictionary = self.processResponse(responseData!)
        
        DispatchQueue.main.async {
            completion(responseDictionary,self.errorMessage)
        }
    }
    
    private func readJson(file:String) -> Data?{
        var data:Data?
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: file, ofType: "json")!
        data = NSData(contentsOfFile: path) as Data?
        
        return data
    }
    
    // Process the response data and convert to Dictionary
    fileprivate func processResponse(_ data:Data) -> responseDictionary? {
        var responseDictionary: responseDictionary?
        
        do {
            responseDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? responseDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return nil
        }
        
        return responseDictionary
    }
}

