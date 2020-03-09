//
//  MovieCollectionCell.swift
//  TheMovieDB
//
//  Created by Tal Lerman on 06/03/2020.
//  Copyright © 2020 Tal Lerman. All rights reserved.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name:      UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = UIImage(named: "placeholder")
    }
    
    func setup(with movie: Movie) {
        name.text = movie.title
        
        movie.posterImage { (result) in
            switch result {
            case .success(let image):
                self.imageView.image = image
                self.reloadInputViews()
            case .failure(let error):
                print(error)
            }
        }
    }
}
