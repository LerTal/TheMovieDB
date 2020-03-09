//
//  ServerCalls.swift
//  TheMovieDB
//
//  Created by Tal Lerman on 05/03/2020.
//  Copyright © 2020 Tal Lerman. All rights reserved.
//

import Foundation
import UIKit

class NetworkClient {
    
    // MARK: - Private Properties
    private let language = "en-US"
    private let apiKey   = "60ecc56a82fb6c7d544a557ce4bc47c2"
    private let session  = URLSession.shared
    
    private let baseURLComponents: URLComponents = {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host   = "api.themoviedb.org"
        urlComponents.path   = "/3"
        return urlComponents
    }()
    
    // MARK: - Constractor
    
    public static let shared: NetworkClient = {
        return NetworkClient()
    }()
    
    // MARK: - Object Lifecycle
    
    private init() {
        //...
    }
    
    // MARK: - URL Generators
    
    private func configurationURL() -> URL? {
        var urlComponents = baseURLComponents
        urlComponents.path.append("/configuration")
        urlComponents.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        return urlComponents.url
    }
    
    private func genresURL() -> URL? {
        var urlComponents = baseURLComponents
        urlComponents.path.append("/genre/movie/list")
        urlComponents.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        return urlComponents.url
    }
    
    private func popularMoviesURL(page: Int) -> URL? {
        var urlComponents = baseURLComponents
        urlComponents.path.append("/movie/popular")
        urlComponents.queryItems = [ URLQueryItem(name: "api_key" , value: apiKey),
                                     URLQueryItem(name: "language", value: language),
                                     URLQueryItem(name: "page"    , value: "\(page)")]
                                   //URLQueryItem(name: "region"  , value: "")
        
        return urlComponents.url
    }
    
    private func moviesURL(search text: String, page: Int) -> URL? {
        var urlComponents = baseURLComponents
        urlComponents.path.append("/search/movie")
        urlComponents.queryItems = [ URLQueryItem(name: "api_key"       , value: apiKey),
                                     URLQueryItem(name: "language"      , value: language),
                                     URLQueryItem(name: "query"         , value: text),
                                     URLQueryItem(name: "page"          , value: "\(page)"),
                                     URLQueryItem(name: "include_adult" , value: "\(false)")]
                                   //URLQueryItem(name: "region"        , value: "")
                                   //URLQueryItem(name: "year"          , value: "")
                                   //URLQueryItem(name: "primary_release_year" , value: "")
        
        return urlComponents.url
    }
    
    private func discoverMoviesURL(page: Int, genresIds: [Int]?, sortBy: SortTypeDiscoverMoviesURL?) -> URL? {     // TODO: update and extend more options
        var urlComponents = baseURLComponents
        urlComponents.path.append("/discover/movie")
        urlComponents.queryItems = [ URLQueryItem(name: "api_key"       , value: apiKey),
                                     URLQueryItem(name: "language"      , value: language),
                                     URLQueryItem(name: "page"          , value: "\(page)"),
                                     URLQueryItem(name: "include_adult" , value: "\(false)")]
        
        if let genresIds = genresIds {
            let genresIdsString = "\(genresIds)".trimmingCharacters(in: ["[","]"] )
            urlComponents.queryItems?.append(URLQueryItem(name: "with_genres", value: genresIdsString))
        }
        
        if let sortBy = sortBy {
            urlComponents.queryItems?.append(URLQueryItem(name: "sort_by", value: sortBy.rawValue))
        }
        
        return urlComponents.url
    }
    
    private func movieVideosURL(for movieID: String) -> URL? {
        var urlComponents = baseURLComponents
        urlComponents.path.append("/movie/\(movieID)/videos")
        urlComponents.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        return urlComponents.url
    }
    
    // MARK: - Public Functions
    
    public func configuration(completion: @escaping (Result<Configuration, NetworkError>) -> Void ) {
        
        loadJSON(objType: Configuration.self, url: configurationURL()) { (result) in
            completion(result)
        }
    }
    
    public func genres(completion: @escaping (Result<Genres, NetworkError>) -> Void ) {
        
        loadJSON(objType: Genres.self, url: genresURL()) { (result) in
            completion(result)
        }
    }
    
    public func popularMovies(page: Int, completion: @escaping (Result<Movies, NetworkError>) -> Void ) {
        
        loadJSON(objType: Movies.self, url: popularMoviesURL(page: page)) { (result) in
            completion(result)
        }
    }
    
    public func movies(search text: String, page: Int, completion: @escaping (Result<Movies, NetworkError>) -> Void ) {
        
        loadJSON(objType: Movies.self, url: moviesURL(search: text, page: page)) { (result) in
            completion(result)
        }
    }
    
    public func discoverMovies(page: Int, genresIds: [Int]? = nil, sortBy: SortTypeDiscoverMoviesURL? = nil, completion: @escaping (Result<Movies, NetworkError>) -> Void ) {
        
        loadJSON(objType: Movies.self, url: discoverMoviesURL(page: page, genresIds: genresIds, sortBy: sortBy)) { (result) in
            completion(result)
        }
    }
    
    public func movieVideos(for movieID: String, completion: @escaping (Result<Videos, NetworkError>) -> Void ) {
        
        loadJSON(objType: Videos.self, url: movieVideosURL(for: movieID)) { (result) in
            completion(result)
        }
    }
    
    // MARK: - ...

    private func loadJSON<T: Decodable>(objType: T.Type, url: URL?, completion: @escaping (Result<T, NetworkError>) -> Void ) {

        let success: (T) -> Void = { obj in
            DispatchQueue.main.async { completion(Result.success(obj)) }
        }

        let failure: (NetworkError) -> Void = { error in
            DispatchQueue.main.async { completion(Result.failure(error)) }
        }

        guard let url = url else {
            failure(NetworkError.EmptyURLError)
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in

            if let error = error {
                failure(NetworkError.RequestFailedError(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
                else {
                    failure(NetworkError.BadURLResponseError(response))
                    return
            }

            guard let data = data
                else {
                failure((NetworkError.EmptyDataError))
                return
            }

            do {
                let decoder = JSONDecoder()
                let obj = try decoder.decode(T.self, from: data)
                success(obj)
            }
            catch {
                if let image = UIImage(data: data) {
                    print(image)
                }
                failure(NetworkError.JSONDecoderError(type: T.self, error: error))
            }
            
        }
        task.resume()
    }
    
    func downloadImage(url: URL?, completion: @escaping (Result<UIImage, NetworkError>) -> Void ) {

        let success: (UIImage) -> Void = { obj in
            DispatchQueue.main.async { completion(Result.success(obj)) }
        }

        let failure: (NetworkError) -> Void = { error in
            DispatchQueue.main.async { completion(Result.failure(error)) }
        }

        guard let url = url else {
            failure(NetworkError.EmptyURLError)
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in

            if let error = error {
                failure(NetworkError.RequestFailedError(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
                else {
                    failure(NetworkError.BadURLResponseError(response))
                    return
            }

            guard let data = data
                else {
                failure((NetworkError.EmptyDataError))
                return
            }

            guard let image = UIImage(data: data) else {
                failure(NetworkError.FailedLoadImage)
                return
            }
            success(image)
            
        }
        task.resume()
    }
    
}
