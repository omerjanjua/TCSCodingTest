//
//  Service.swift
//  TCSCodingTest
//
//  Created by Omer Janjua on 07/03/2018.
//  Copyright © 2018 Omer Janjua. All rights reserved.
//

import Foundation

let apiKey = "d0c06c9e381c603cfe878d03dd0014f8"
let baseURL = "https://api.themoviedb.org/3"
let nowPlayingURL = "/movie/now_playing/"
let movieURL = "/movie/"
let collectionURL = "/collection/"
let imageBaseURL = "https://image.tmdb.org/t/p/w300"

typealias responseDictionary = [String: Any]

protocol Servicing {
    func fetchNowPlayingMovies(completion: @escaping (responseDictionary?, String) -> ())
    func fetchMovieDetails(movieID:Int, completion: @escaping (responseDictionary?, String) -> ())
    func fetchMovieCollection(collectionID:Int, completion: @escaping (responseDictionary?, String) -> ())
}

class Service: Servicing {
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func fetchNowPlayingMovies(completion: @escaping (responseDictionary?, String) -> ()) {
        guard let nowPlaying = constructURLFor(service: nowPlayingURL) else { return }
        fetchDataFor(url: nowPlaying, completion: completion)
    }
    
    func fetchMovieDetails(movieID:Int, completion: @escaping (responseDictionary?, String) -> ()) {
        guard let movieDetail = constructURLFor(service: movieURL+(String(movieID))) else { return }
        fetchDataFor(url: movieDetail, completion: completion)
    }
    
    func fetchMovieCollection(collectionID:Int, completion: @escaping (responseDictionary?, String) -> ()) {
        guard let movieCollection = constructURLFor(service: collectionURL+String(collectionID)) else { return }
        fetchDataFor(url: movieCollection, completion: completion)
    }
    
    fileprivate func fetchDataFor(url: URL, completion : @escaping (responseDictionary?, String) -> ()) {
        var responseDictionary: responseDictionary?
        var serverError = ""
        
        dataTask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if let error = error {
                serverError = "Server error:" + error.localizedDescription
                print(serverError)
            }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                responseDictionary = self.parseData(data: data)
            }
            
            DispatchQueue.main.async {
                completion(responseDictionary, serverError)
            }
        })
        dataTask?.resume()
    }
    
    fileprivate func constructURLFor(service: String) -> URL? {
        let urlString = baseURL+service+"?api_key="+apiKey
        
        guard let url = URL(string:urlString) else {
            return nil
        }
        return url
    }
    
    fileprivate func parseData(data: Data) -> responseDictionary? {
        var responseDictionary: responseDictionary?
        
        do {
            responseDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? responseDictionary
        } catch let error as NSError {
            print("Failed to serialize JSON:" + error.localizedDescription)
            return nil
        }
        
        return responseDictionary
    }
}
