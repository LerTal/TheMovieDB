//
//  MovieTableCell.swift
//  TheMovieDB
//
//  Created by Tal Lerman on 07/03/2020.
//  Copyright © 2020 Tal Lerman. All rights reserved.
//

import UIKit

class MovieTableCell: UITableViewCell {
    
    var cellIndex: Int? {
        willSet {
            if (cellNumber != nil) && (newValue != nil) {
                cellNumber.text = String(newValue!)
            }
        }
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var name:           UILabel!
    @IBOutlet weak var cellNumber:     UILabel!
    @IBOutlet weak var genres:         UILabel!
    @IBOutlet weak var date:           UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        movieImageView.image = UIImage(named: "placeholder")
    }
    
    func setup(with movie: Movie) {
        name.text   = movie.title
        genres.text = movie.genreIdsText
        date.text   = movie.releaseDateText
        
        movie.posterImage { (result) in
            switch result {
            case .success(let image):
                self.movieImageView.image = image
                self.reloadInputViews()
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
