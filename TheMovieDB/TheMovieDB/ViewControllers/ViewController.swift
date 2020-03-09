//
//  ViewController.swift
//  TheMovieDB
//
//  Created by Tal Lerman on 05/03/2020.
//  Copyright © 2020 Tal Lerman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        NetworkClient.shared.configuration { (result) in
            switch result {
            case .success(let configuration):
                print(configuration)
            case .failure(let error):
                print(error)
            }
        }
        
        NetworkClient.shared.genres{ (result) in
            switch result {
            case .success(let genres):
                for genre in genres.genres {
                    print(genre)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        NetworkClient.shared.popularMovies(page: 1, completion: { (result) in
            switch result {
            case .success(let movies):
                for movie in movies.results {
                    print(movie)
                }
            case .failure(let error):
                print(error)
            }
        })

        NetworkClient.shared.movies(search: "the last samurai", page: 1, completion: { (result) in
            switch result {
            case .success(let movies):
                for movie in movies.results {
                    print(movie)
                }
            case .failure(let error):
                print(error)
            }
        })

//        NetworkClient.shared.discoverMovies(page: 1, completion: { (result) in
//            switch result {
//            case .success(let movies):
//                for movie in movies.results {
//                    print(movie)
//                }
//            case .failure(let error):
//                print(error)
//            }
//        })
        
        NetworkClient.shared.movieVideos(for: "512200", completion: { (result) in
            switch result {
            case .success(let videos):
                for video in videos.results {
                    print(video)
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    
}

