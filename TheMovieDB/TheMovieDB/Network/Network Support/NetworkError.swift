//
//  ServerCallsError.swift
//  TheMovieDB
//
//  Created by Tal Lerman on 05/03/2020.
//  Copyright © 2020 Tal Lerman. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case EmptyURLError
    case EmptyDataError
    case FailedLoadImage
    case RequestFailedError(Error)
    case JSONDecoderError(type: Decodable.Type, error: Error)
    case BadURLResponseError(URLResponse?)
}
