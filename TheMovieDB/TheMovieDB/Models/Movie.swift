//
//  Movie.swift
//  TheMovieDB
//
//  Created by Tal Lerman on 05/03/2020.
//  Copyright © 2020 Tal Lerman. All rights reserved.
//

import UIKit

struct Movies: Codable {
    let page:         Int
    let totalResults: Int
    let totalPages:   Int
    let results:      [Movie]
    
    
    // CodingKey
    enum CodingKeys: String, CodingKey {
        case page           //= "page"
        case totalResults   = "total_results"
        case totalPages     = "total_pages"
        case results        //= "results"
    }
}

struct Movie: Codable {
    let popularity:       Float
    let voteCount:        Int
    let video:            Bool
    let posterPath:       String?
    let id:               Int
    let adult:            Bool
    let backdropPath:     String?
    let originalLanguage: String
    let originalTitle:    String
    let genreIds:         [Int]
    let title:            String
    let voteAverage:      Float
    let overview:         String
    let releaseDate:      Date?
    
    var releaseDateText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        var res = "------"
        if let releaseDate = releaseDate {
            res = dateFormatter.string(from: releaseDate)
        }
        return res
    }
    
    var genreIdsText: String {
        let genreList = genreIds.compactMap { (id) -> String? in
            return Genre.getGenre(id: id)
        }
//        let text = "\(genreList)".trimmingCharacters(in: ["[", "]", "\""])
        var text = ""
        for (index, name) in genreList.enumerated() {
            let s = ((index == 0) ? name : ", \(name)")
            text.append( s )
        }
        return text
    }
    
    func posterImage(completion: @escaping (Result<UIImage, NetworkError>) -> Void)  {
        guard let posterPath = self.posterPath else { return }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https" 
        urlComponents.host   = "image.tmdb.org"
        urlComponents.path   = "/t/p/\(PosterSizes.w185)\(posterPath)"
        
        if let url = urlComponents.url {
            NetworkClient.shared.downloadImage(url: url) { (result) in
                completion(result)
            }
        }
    }
    
    func backdropImage(completion: @escaping (Result<UIImage, NetworkError>) -> Void)  {
        guard let backdropPath = self.backdropPath else { return }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host   = "image.tmdb.org"
        urlComponents.path   = "/t/p/\(BackdropSizes.w780)\(backdropPath)"
        
        if let url = urlComponents.url {
            NetworkClient.shared.downloadImage(url: url) { (result) in
                completion(result)
            }
        }
    }
    
    // CodingKey
    enum CodingKeys: String, CodingKey {
        case popularity         //= "popularity"
        case voteCount          = "vote_count"
        case video              //= "video"
        case posterPath         = "poster_path"
        case id                 //= "id"
        case adult              //= "adult"
        case backdropPath       = "backdrop_path"
        case originalLanguage   = "original_language"
        case originalTitle      = "original_title"
        case genreIds           = "genre_ids"
        case title              //= "title"
        case voteAverage        = "vote_average"
        case overview           //= "overview"
        case releaseDate        = "release_date"
    }
    
    // Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        popularity = try container.decode(Float.self, forKey: .popularity)
        voteCount = try container.decode(Int.self, forKey: .voteCount)
        video = try container.decode(Bool.self, forKey: .video)
        posterPath = try? container.decode(String.self, forKey: .posterPath)
        id = try container.decode(Int.self, forKey: .id)
        adult = try container.decode(Bool.self, forKey: .adult)
        backdropPath = try? container.decode(String.self, forKey: .backdropPath)
        originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        originalTitle = try container.decode(String.self, forKey: .originalTitle)
        genreIds = try container.decode([Int].self, forKey: .genreIds)
        title = try container.decode(String.self, forKey: .title)
        voteAverage = try container.decode(Float.self, forKey: .voteAverage)
        overview = try container.decode(String.self, forKey: .overview)
        
        let date = try? container.decode(String.self, forKey: .releaseDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        releaseDate = ((date != nil) ? dateFormatter.date(from: date!) : nil)
    }
    
    // Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
       try container.encode(popularity, forKey: .popularity)
       try container.encode(voteCount, forKey: .voteCount)
       try container.encode(video, forKey: .video)
       try container.encode(posterPath, forKey: .posterPath)
       try container.encode(id, forKey: .id)
       try container.encode(adult, forKey: .adult)
       try container.encode(backdropPath, forKey: .backdropPath)
       try container.encode(originalLanguage, forKey: .originalLanguage)
       try container.encode(originalTitle, forKey: .originalTitle)
       try container.encode(genreIds, forKey: .genreIds)
       try container.encode(title, forKey: .title)
       try container.encode(voteAverage, forKey: .voteAverage)
       try container.encode(overview, forKey: .overview)
       try container.encode(releaseDate, forKey: .releaseDate)
    }
    
}
