//
//  NowPlayingModel.swift
//  TCSCodingTest
//
//  Created by Omer Janjua on 07/03/2018.
//  Copyright © 2018 Omer Janjua. All rights reserved.
//

import UIKit

class Movie {
    let id: Int
    let title: String
    var imagePath: String?
    var image: UIImage?
    var overview: String?
    var isPartOfCollection : Bool = false
    var collectionID: Int?
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
}
