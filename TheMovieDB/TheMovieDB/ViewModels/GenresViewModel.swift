//
//  GenresViewModel.swift
//  TheMovieDB
//
//  Created by Tal Lerman on 06/03/2020.
//  Copyright © 2020 Tal Lerman. All rights reserved.
//

import Foundation

protocol GenresViewModelDelegate: class {
    func finishedReloadGenres()
}

class GenresViewModel {
    
    private var genres: [Genre] = [Genre(id: 0, name: "All")]
    weak var delegate: GenresViewModelDelegate?
    
    func start() {
        if let genresForUserDefaults = getGenresInUserDefaults() {
            self.genres = genresForUserDefaults
            self.delegate?.finishedReloadGenres()
            return
        }
        
        NetworkClient.shared.genres{ (result) in
            switch result {
            case .success(let genres):
                self.genres.append(contentsOf: genres.genres)
                self.delegate?.finishedReloadGenres()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func cellCount() -> Int {
        return genres.count
    }
    
    func movie(at index: Int) -> Genre? {
        if (genres.count < index) { return nil }
        return genres[index]
    }
    
    func updateGenres(filtered: Bool) {
        for genre in genres {
            genre.filtered = filtered
        }
    }
    
    func updateGenres(highlighted: Bool) {
        for genre in genres {
             genre.highlighted = highlighted
        }
    }

    func updateGenres(filtered: Bool, index: Int) {
        genres[index].filtered = filtered
    }
    
    func updateGenres(highlighted: Bool, index: Int) {
        genres[index].highlighted = highlighted
    }
    
    func filterdCount() -> Int {
        var res = 0
        for genre in genres {
            if (genre.filtered == true) {
                res += 1
            }
        }
        return res
    }
    
    func highlightedCount() -> Int {
        var res = 0
        for genre in genres {
            if (genre.highlighted == true) {
                res += 1
            }
        }
        return res
    }
    
    func filterdIds() -> [Int] {
        var res = [Int]()
        for genre in genres {
            if (genre.filtered == true) {
                res.append(genre.id)
            }
        }
        return res
    }
    
    func highlightedIds() -> [Int] {
        var res = [Int]()
        for genre in genres {
            if (genre.highlighted == true) {
                res.append(genre.id)
            }
        }
        return res
    }
    
    func saveGenresInUserDefaults() {
        _ = UserDefaults.standard.setGenres(self.genres)
    }
    
    func getGenresInUserDefaults() -> [Genre]? {
        return UserDefaults.standard.getGenres()
    }
    
}
