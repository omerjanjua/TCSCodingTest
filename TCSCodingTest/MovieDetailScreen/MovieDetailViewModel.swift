//
//  MovieDetailViewModel.swift
//  TCSCodingTest
//
//  Created by Omer Janjua on 08/03/2018.
//  Copyright © 2018 Omer Janjua. All rights reserved.
//

import SDWebImage

class MovieDetailViewModel {
    var movie: Movie?
    
    init(selectedMovie: Movie) {
        movie = selectedMovie
    }
    
    func getMovieDetails() -> Movie  {
        let imageView = UIImageView()
        if let image = self.movie?.imagePath {
            imageView.sd_setImage(with: URL(string: imageBaseURL + image), placeholderImage: #imageLiteral(resourceName: "placeholder_icon"))
        }
        movie?.image = imageView.image
        return movie!
    }
}
