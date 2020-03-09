//
//  DetailsViewModel.swift
//  TheMovieDB
//
//  Created by Tal Lerman on 06/03/2020.
//  Copyright © 2020 Tal Lerman. All rights reserved.
//

import Foundation

protocol DetailsViewModelDelegate: class {
    func aaaaa()
}

class DetailsViewModel {
    
    var movie: Movie? {
        willSet {
            print("-----willSet-----\(String(describing: newValue))")
            guard let movieID = newValue?.id else {
                return
                
            }
            
            NetworkClient.shared.movieVideos(for: "\(movieID)") { (result) in
                switch result {
                case .success(let videos):
                    self.videos = videos
                case .failure(let error):
                    print(error)
                }
            }
        }
        didSet {
            print("-----didSet-----\(String(describing: oldValue))")
        }
    }
    var videos: Videos?
    weak var delegate: DetailsViewModelDelegate?
    
    init(movie: Movie) {
        self.movie = movie
        
        updateVideo(movieId: movie.id)
    }
    
    func updateVideo(movieId: Int) {
        NetworkClient.shared.movieVideos(for: "\(movieId)") { (result) in
            switch result {
            case .success(let videos):
                self.videos = videos
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func information() -> String? {
        guard let movie = self.movie else { return nil }
        let infoText =
        """
                         Rate   \(movie.voteAverage)
                      Genre   \(movie.genreIdsText)
             In Theaters   \(movie.releaseDateText)
        Original Name   \(movie.originalTitle)
        """
        
        return infoText
    }
}
