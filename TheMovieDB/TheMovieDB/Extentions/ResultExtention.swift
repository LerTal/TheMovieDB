//
//  ResultExtention.swift
//  TheMovieDB
//
//  Created by Tal Lerman on 06/03/2020.
//  Copyright © 2020 Tal Lerman. All rights reserved.
//

import Foundation

extension Result {
    
    func getValue() -> Any? {
        switch self {
        case .success(let value):
            return value
        case .failure(_):
            return nil
        }
    }
    
}

