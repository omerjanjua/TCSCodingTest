//
//  MovieCollectionModel.swift
//  TCSCodingTest
//
//  Created by Omer Janjua on 07/03/2018.
//  Copyright © 2018 Omer Janjua. All rights reserved.
//

import UIKit

class Collection {
    let collectionID: Int
    let collectionName: String
    var imagePath: String?
    var image: UIImage?
    var overView: String?
    var movies: [Movie] = []
    
    init(id: Int, title: String) {
        self.collectionID = id
        self.collectionName = title
    }
}
