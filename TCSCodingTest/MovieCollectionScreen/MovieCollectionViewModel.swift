//
//  MovieCollectionViewModel.swift
//  TCSCodingTest
//
//  Created by Omer Janjua on 07/03/2018.
//  Copyright © 2018 Omer Janjua. All rights reserved.
//

import UIKit
import SDWebImage

class MovieCollectionViewModel {
    
    fileprivate var service: Servicing?
    fileprivate var selectedCellIndexPath: IndexPath?
    fileprivate var collectionID: Int?
    var movies: [Movie] = []
    var collection: Collection?
    
    init(collectionID: Int) {
        service = Service()
        self.collectionID = collectionID
    }
    
     func fetchCollectionDetails(imageView: UIImageView, callback: @escaping (Bool,String,Collection?)->()) -> () {
        
        guard let collectionID = collectionID else { return }
        service?.fetchMovieCollection(collectionID: collectionID, completion: { [weak self] (responseDictionary, error) in
            
            if let responseDictionary = responseDictionary,
                let collectionID = responseDictionary["id"] as? Int,
                let collectionName = responseDictionary["name"] as? String {
                self?.collection = Collection(id: collectionID, title: collectionName)
                if let imagePath = responseDictionary["poster_path"] as? String {
                    self?.collection?.imagePath = imagePath
                }
                self?.collection?.overView = responseDictionary["overview"] as? String
                
                if let imagePath = self?.collection?.imagePath {
                    imageView.sd_setImage(with: URL(string: imageBaseURL + imagePath), placeholderImage: #imageLiteral(resourceName: "placeholder_icon"))
                }
                self?.collection?.image = imageView.image
                
                guard let movieCollection = responseDictionary["parts"] as? [Any] else {
                    callback(false, "Failed to fetch movie collection", nil)
                    return
                }
                
                if movieCollection.count == 0 {
                    callback(false, "No parts to this collection", nil)
                }
                
                for movie in movieCollection {
                    if let movie = movie as? responseDictionary,
                        let movieID = movie["id"] as? Int,
                        let movieName = movie["title"] as? String {
                        let movieModel = Movie(id: movieID, title: movieName)
                        movieModel.overview = movie["overview"] as? String

                        if let imagePath = movie["poster_path"] as? String {
                            movieModel.imagePath = imagePath
                        }
                        
                        self?.movies.append(movieModel)
                    }
                }
                callback(true, "", self?.collection)
                
            } else {
                callback(false, "Failed to fetch collection data", nil)
            }
        })
    }
}

extension MovieCollectionViewModel {
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

extension MovieCollectionViewModel {
    func setSelectedCellIndexPath(indexPath: IndexPath) {
        selectedCellIndexPath = indexPath
    }
    
    func getMovieDetailViewModel() -> MovieDetailViewModel {
        let movie = self.movies[selectedCellIndexPath!.row]
        let movieDetailViewModel = MovieDetailViewModel(selectedMovie: movie)
        return movieDetailViewModel
    }
}
