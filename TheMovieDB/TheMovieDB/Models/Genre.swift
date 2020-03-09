//
//  Genre.swift
//  TheMovieDB
//
//  Created by Tal Lerman on 05/03/2020.
//  Copyright © 2020 Tal Lerman. All rights reserved.
//

import UIKit

struct Genres: Codable {
    let genres: [Genre]     // TODO: chnage property name
}

class Genre: Codable, Equatable {
    let id:   Int
    let name: String
    
    var filtered    = false
    var highlighted = false
    
    lazy var icon: UIImage? = {
        //guard let imageName = genreImageName[name],
        guard let imageName = genreImageName[id],
              let image     = UIImage(named: imageName)
            else {
                print("Warning: not find icon for '\(name)' genre (\(id) ID)")
                return nil
        }
        return image
    }()
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    // CodingKey
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case filtered
        case highlighted
    }
    
    // Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        filtered = (try? container.decode(Bool.self, forKey: .filtered)) ?? false
        highlighted = (try? container.decode(Bool.self, forKey: .highlighted)) ?? false
    }
    
    // Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(filtered, forKey: .filtered)
        try container.encode(highlighted, forKey: .highlighted)
    }
    
    // Equatable
    static func == (lhs: Genre, rhs: Genre) -> Bool {
        return ( (lhs.id == rhs.id) && (lhs.name == rhs.name) && (lhs.filtered == rhs.filtered) && (lhs.highlighted == rhs.highlighted) )
    }
    
    // ...
    class func getGenre(id: Int) -> String? {
        return genreImageName[id]
    }
}


private let genreImageName: [Int: String] = [
    28      : "action",
    12      : "adventure",
    16      : "animation",
    35      : "comedy",
    80      : "crime",
    99      : "documentary",
    18      : "drama",
    10751   : "family",
    14      : "fantasy",
    36      : "history",
    27      : "horror",
    10402   : "music",
    9648    : "mystery",
    10749   : "romance",
    878     : "sf",
    10770   : "tv",
    53      : "thriller",
    10752   : "war",
    37      : "western"]

