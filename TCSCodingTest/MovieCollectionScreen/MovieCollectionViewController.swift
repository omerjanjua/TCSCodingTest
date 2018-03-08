//
//  MovieCollectionViewController.swift
//  TCSCodingTest
//
//  Created by Omer Janjua on 07/03/2018.
//  Copyright © 2018 Omer Janjua. All rights reserved.
//

import UIKit

class MovieCollectionViewController: UIViewController {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieDescription: UITextView!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: MovieCollectionViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.fetchCollectionDetails(imageView: movieImageView, callback: { [weak self] (success, error, collection) in
            if success {
                guard let collection = collection else { return }
                self?.reloadCollectionViewData(collection: collection)
            } else {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
            self?.activityIndicator.stopAnimating()
        })
    }

    func reloadCollectionViewData(collection: Collection){
        movieCollectionView?.reloadData()
        navigationItem.title = collection.collectionName
        movieDescription.text = collection.overView
        movieImageView.image = collection.image
    }
}

extension MovieCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel!.numberOfSectionsInCollectionView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel!.numberOfItemsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel!.setUpCollectionViewCell(indexPath: indexPath, collectionView : collectionView)
    }
}

extension MovieCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel!.setSelectedCellIndexPath(indexPath: indexPath)
        performSegue(withIdentifier: "collectionDetailSegue", sender: self)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collectionDetailSegue"{
            let vc = segue.destination as! MovieDetailViewController
            vc.viewModel = viewModel!.getMovieDetailViewModel()
        }
    }
}
