//
//  MoviesAViewModel.swift
//  TheMovieDB
//
//  Created by Tal Lerman on 06/03/2020.
//  Copyright © 2020 Tal Lerman. All rights reserved.
//

import Foundation

protocol MoviesAViewModelDelegate: class {
    func finishedReloadMovies()
}

class MoviesAViewModel {
    
    private var movies = [Movie]()
    private var lastGenresForUserDefaults: [Genre]?
    weak var delegate: MoviesAViewModelDelegate?
    
    var titleForVC: String {
        var title = "Most Popular"
        if let genresForUserDefaults = lastGenresForUserDefaults {
            let filteredGenresNames: [String] = genresForUserDefaults.compactMap { (genre) -> String? in
                return (genre.filtered ? genre.name : nil)
            }
            switch filteredGenresNames.count {
            case 0:
                title = "Most Popular"  //"Genres is Clear"
            case 1:
                title = filteredGenresNames.first!
            case 2:
                title = "\(filteredGenresNames[0]) & \(filteredGenresNames[1])"
            case genresForUserDefaults.count-1,
                 genresForUserDefaults.count:
                title = "All Genres"
            default:
                title = "\(filteredGenresNames[0]) & \(filteredGenresNames[1]) & ..."
            }
        }
        return title
    }
    
    var resetScrollToStart: Bool {
        var res = false
        if (lastGenresForUserDefaults != getGenresInUserDefaults()) {
            res = true
        }
        return res
    }
    
    func start() {
        let pages = 5
        
        let completion: ((Result<Movies, NetworkError>) -> Void) = { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let movies):
                self.movies.append(contentsOf: movies.results)
                self.delegate?.finishedReloadMovies()
            case .failure(let error):
                print(error)
            }
        }
        
        if let genresForUserDefaults = getGenresInUserDefaults() {
            if (lastGenresForUserDefaults != genresForUserDefaults) {
                self.movies = [Movie]()
            }
            lastGenresForUserDefaults = genresForUserDefaults
            
            let genresIdsToFilterBy: [Int] = genresForUserDefaults.compactMap { (genre) -> Int? in
                return (genre.filtered ? genre.id : nil)
            }
            
            for i in 1...pages {
                NetworkClient.shared.discoverMovies(page: i, genresIds: genresIdsToFilterBy, completion: completion)
            }
        }
        else {
            for i in 1...pages {
                NetworkClient.shared.popularMovies(page: i, completion: completion)
            }
        }
        
        
        
    }
    
    func getGenresInUserDefaults() -> [Genre]? {
        return UserDefaults.standard.getGenres()
    }
    
    func cellCount() -> Int {
        return movies.count
    }
    
    func movie(at index: Int) -> Movie? {
        if (movies.count < index) { return nil }
        return movies[index]
    }
    
}
