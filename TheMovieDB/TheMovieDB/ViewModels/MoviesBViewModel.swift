//
//  MoviesBViewModel.swift
//  TheMovieDB
//
//  Created by Tal Lerman on 06/03/2020.
//  Copyright © 2020 Tal Lerman. All rights reserved.
//

import Foundation

enum FilterType {
    case popular, rating
}

protocol MoviesBViewModelDelegate: class {
    func finishedReloadMovies()
}

class MoviesBViewModel {
    
    // MARK: - Properties
    private var popularMovies = [Movie]()
    private var ratingMovies  = [Movie]()
    
    weak var delegate: MoviesBViewModelDelegate?
    
    // MARK: - start
    
    func start(filterType: FilterType) {
        switch filterType {
        case .popular:
            startPopularMovies()
        case .rating:
            startRatingMovies()
        }
    }
    
    fileprivate func startPopularMovies() {
        if (popularMovies.count > 0) {
            self.delegate?.finishedReloadMovies()
            return
        }
        
        let pages = 5
        for i in 1...pages {
            NetworkClient.shared.popularMovies(page: i) { [weak self] (result) in
                guard let self = self else { return }
                
                switch result {
                case .success(let movies):
                    self.popularMovies.append(contentsOf: movies.results)
                    self.delegate?.finishedReloadMovies()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    fileprivate func startRatingMovies() {
        if (ratingMovies.count > 0) {
            self.delegate?.finishedReloadMovies()
            return
        }
        
        let pages = 5
        for i in 1...pages {
            NetworkClient.shared.discoverMovies(page: i, sortBy: .voteAverageDesc) { [weak self] (result) in
                guard let self = self else { return }
                
                switch result {
                case .success(let movies):
                    self.ratingMovies.append(contentsOf: movies.results)
                    self.delegate?.finishedReloadMovies()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: - ...
    
    fileprivate func movies(filterType: FilterType) -> [Movie] {
        let movieList: [Movie]
        switch filterType {
        case .popular:
            movieList = popularMovies
        case .rating:
            movieList = ratingMovies
        }
        return movieList
    }
    
    func cellCount(filterType: FilterType) -> Int {
        return movies(filterType: filterType).count
    }
    
    func movie(filterType: FilterType, at index: Int) -> Movie? {
        if (movies(filterType: filterType).count < index) { return nil }
        return movies(filterType: filterType)[index]
    }
}
