//
//  NowPlayingViewController.swift
//  TCSCodingTest
//
//  Created by Omer Janjua on 07/03/2018.
//  Copyright © 2018 Omer Janjua. All rights reserved.
//

import UIKit

class NowPlayingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    fileprivate var viewModel: NowPlayingViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = NowPlayingViewModel(reloadCollectionViewCallback: reloadCollectionViewData)
    }

    func reloadCollectionViewData(success: Bool, error: String) {
        if success {
            collectionView.reloadData()
        } else {
            let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        activityIndicator.stopAnimating()
    }
}

extension NowPlayingViewController: UICollectionViewDataSource {
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

extension NowPlayingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.setSelectedCellIndexPath(indexPath: indexPath)
        if (viewModel?.isPartOfCollection)! {
            performSegue(withIdentifier: "movieCollectionSegue", sender: self)
        }else {
            performSegue(withIdentifier: "movieDetailSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetailSegue"{
            let vc = segue.destination as! MovieDetailViewController
            vc.viewModel = viewModel?.getMovieDetailViewModel()
        }
        else if segue.identifier == "movieCollectionSegue"{
            let vc = segue.destination as! MovieCollectionViewController
            vc.viewModel = viewModel?.getMovieCollectionViewModel()
        }
    }
}
