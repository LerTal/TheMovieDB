//
//  Configuration.swift
//  TheMovieDB
//
//  Created by Tal Lerman on 06/03/2020.
//  Copyright © 2020 Tal Lerman. All rights reserved.
//

import Foundation


struct Configuration: Codable {
    let images:     Images?
    let changeKeys: [String]?
    
    
    // CodingKey
    enum CodingKeys: String, CodingKey {
        case images
        case changeKeys = "change_keys"
    }
    
    
    // MARK: Images
    
    struct Images: Codable {
        let baseUrl:        String?
        let secureBaseUrl:  String?
        let backdropSizes:  [String]?
        let logoSizes:      [String]?
        let posterSizes:    [String]?
        let profileSizes:   [String]?
        let stillSizes:     [String]?


        // CodingKey
        enum CodingKeys: String, CodingKey {
            case baseUrl        = "base_url"
            case secureBaseUrl  = "secure_base_url"
            case backdropSizes  = "backdrop_sizes"
            case logoSizes      = "logo_sizes"
            case posterSizes    = "poster_sizes"
            case profileSizes   = "profile_sizes"
            case stillSizes     = "still_sizes"
        }
    }
}
