//
//  UserDefaultsExtension.swift
//  TheMovieDB
//
//  Created by Tal Lerman on 08/03/2020.
//  Copyright © 2020 Tal Lerman. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    private var genresKey: String { return "GenresKey" }
    
    func setGenres(_ genres: [Genre]) -> Bool {
        var res = false
        
        do {
            let encoder = PropertyListEncoder()
            let obj = try encoder.encode(genres)
            UserDefaults.standard.set(obj, forKey: genresKey)
            res = true
        } catch {
            print(error)
        }
        return res
    }
    
    func getGenres() -> [Genre]? {
        var obj: [Genre]? = nil
        if let dataObj = UserDefaults.standard.value(forKey: genresKey) as? Data {
            let decoder = PropertyListDecoder()
            do {
                obj = try decoder.decode([Genre].self, from: dataObj)
            } catch {
                print(error)
            }
        }
        return obj
    }
    
}
