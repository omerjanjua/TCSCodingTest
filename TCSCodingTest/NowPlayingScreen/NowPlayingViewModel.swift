//
//  NowPlayingViewModel.swift
//  TCSCodingTest
//
//  Created by Omer Janjua on 07/03/2018.
//  Copyright © 2018 Omer Janjua. All rights reserved.
//

import UIKit

class NowPlayingViewModel {
    
    fileprivate var service: Servicing
    fileprivate var selectedCellIndexPath: IndexPath?
    var isPartOfCollection = false
    var movies: [Movie] = []
    
    var reloadCollectionViewCallback: ((Bool,String)->())!
    
    init(reloadCollectionViewCallback: @escaping ((Bool,String)->())) {
        self.reloadCollectionViewCallback = reloadCollectionViewCallback
        service = Service()
        fethMovies()
    }
    
    init(service: Servicing, reloadCollectionViewCallback: @escaping ((Bool,String)->())) {
        self.reloadCollectionViewCallback = reloadCollectionViewCallback
        self.service = service
        fethMovies()
    }
    
    fileprivate func fethMovies() {
        service.fetchNowPlayingMovies(completion: { [weak self] (responseDictionary, error) in
            if let responseDictionary = responseDictionary {
                guard let results = responseDictionary["results"] as? [Any] else { return }
                
                for movie in results {
                    if let movie = movie as? responseDictionary,
                        let movieID = movie["id"] as? Int,
                        let movieTitle = movie["title"] as? String,
                        let movieImagePath = movie["poster_path"] as? String,
                        let movieOverview = movie["overview"] as? String {
                        let movieData = Movie(id: movieID, title: movieTitle)
                        movieData.imagePath = movieImagePath
                        movieData.overview = movieOverview
                        
                        self?.movies.append(movieData)
                        self?.fetchMovieDetails(movieID: movieID)
                    }
                }
                self?.reloadCollectionViewCallback(true, "")
            } else {
                self?.reloadCollectionViewCallback(false, "Failed to fetch data")
            }
        })
    }
    
    fileprivate func fetchMovieDetails(movieID: Int) {
        service.fetchMovieDetails(movieID: movieID, completion: { [weak self] (responseDictionary, error) in
            let movieData: Movie? = self?.movies.filter({$0.id == movieID}).first
            if let collactionDetails = responseDictionary!["belongs_to_collection"] as? responseDictionary,
                let id = collactionDetails["id"] as? Int{
                movieData?.isPartOfCollection = true
                movieData?.collectionID = id
            }
            movieData?.overview = responseDictionary!["overview"] as? String
        })
    }
}

extension NowPlayingViewModel {
    func numberOfItemsInSection(section : Int) -> Int {
        return movies.count
    }
    
    func numberOfSectionsInCollectionView() -> Int {
        return 1
    }
    
    func setUpCollectionViewCell(indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NowPlayingCollectionViewCell", for: indexPath) as! NowPlayingCollectionViewCell
        cell.title.text = movies[indexPath.row].title
        if let imagePath = movies[indexPath.row].imagePath {
            cell.image.sd_setImage(with: URL(string: imageBaseURL + imagePath), placeholderImage: #imageLiteral(resourceName: "placeholder_icon"))
        }
        return cell
    }
}

extension NowPlayingViewModel {
    func setSelectedCellIndexPath(indexPath: IndexPath){
        selectedCellIndexPath = indexPath
        let movie = movies[selectedCellIndexPath!.row]
        isPartOfCollection = movie.isPartOfCollection ? true : false
    }

    func getMovieDetailViewModel() -> MovieDetailViewModel {
        let movie = self.movies[selectedCellIndexPath!.row]
        let movieDetailViewModel = MovieDetailViewModel(selectedMovie: movie)
        return movieDetailViewModel
    }

    func getMovieCollectionViewModel() -> MovieCollectionViewModel {
        let movie = self.movies[selectedCellIndexPath!.row]
        let movieCollectionViewModel = MovieCollectionViewModel(collectionID: movie.collectionID!)
        return movieCollectionViewModel

    }
}
