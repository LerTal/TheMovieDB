//
//  Video.swift
//  TheMovieDB
//
//  Created by Tal Lerman on 05/03/2020.
//  Copyright © 2020 Tal Lerman. All rights reserved.
//

import Foundation

struct Videos: Codable {
    let id:      Int
    let results: [Video]
}

struct Video: Codable {
    let id:         String
    let iso_639_1:  String
    let iso_3166_1: String
    let key:        String
    let name:       String
    let site:       String
    let size:       Int
    let type:       String
    
    lazy var url: URL? = {
        return URL(string: "https://www.youtube.com/embed/\(key)")
    }()
}
