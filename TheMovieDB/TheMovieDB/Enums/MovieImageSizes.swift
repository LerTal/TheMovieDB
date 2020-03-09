//
//  MovieImageSizes.swift
//  TheMovieDB
//
//  Created by Tal Lerman on 06/03/2020.
//  Copyright © 2020 Tal Lerman. All rights reserved.
//

import Foundation

enum BackdropSizes: String {
    case w300
    case w780
    case w1280
    case original
}

enum LogoSizes: String {
    case w45
    case w92
    case w154
    case w185
    case w300
    case w500
    case original
}

enum PosterSizes: String {
    case w92
    case w154
    case w185
    case w342
    case w500
    case w780
    case original
}

enum ProfileSizes: String {
    case w45
    case w185
    case h632
    case original
}

enum StillSizes: String {
    case w92
    case w185
    case w300
    case original
}

enum SortTypeDiscoverMoviesURL: String {
    case popularityAsc          = "popularity.asc"
    case popularityDesc         = "popularity.desc"
    case releaseDateAsc         = "release_date.asc"
    case releaseDateDesc        = "release_date.desc"
    case revenueAsc             = "revenue.asc"
    case revenueDesc            = "revenue.desc"
    case primaryReleaseDateAsc  = "primary_release_date.asc"
    case primaryReleaseDateDesc = "primary_release_date.desc"
    case originalTitleAsc       = "original_title.asc"
    case originalTitleDesc      = "original_title.desc"
    case voteAverageAsc         = "vote_average.asc"
    case voteAverageDesc        = "vote_average.desc"
    case voteCountAsc           = "vote_count.asc"
    case voteCountDesc          = "vote_count.desc"
}
