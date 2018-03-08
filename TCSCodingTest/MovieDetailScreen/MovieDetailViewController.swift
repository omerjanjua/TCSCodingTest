//
//  MovieDetailViewController.swift
//  TCSCodingTest
//
//  Created by Omer Janjua on 08/03/2018.
//  Copyright © 2018 Omer Janjua. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieDescription: UITextView!
    var viewModel: MovieDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let movie = viewModel?.getMovieDetails()
        guard let movieImage = movie?.image,
            let movieOverview = movie?.overview,
            let movieTitle = movie?.title else { return }
        movieImageView.image = movieImage
        movieDescription.text = movieOverview
        navigationItem.title = movieTitle
    }
}
