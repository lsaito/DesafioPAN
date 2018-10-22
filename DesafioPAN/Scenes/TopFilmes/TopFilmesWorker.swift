//
//  FilmeWorker.swift
//  DesafioPAN
//
//  Created by Lucas Saito on 20/10/2018.
//  Copyright © 2018 Otias. All rights reserved.
//

import Foundation

class TopFilmesWorker {
    func fetchDiscoverMovie(request: TheMovieDB.DiscoverMovie.Request, completionHandler: @escaping (TheMovieDB.DiscoverMovie.Response) -> Void)
    {
        let parameters = request.toDictionary()
        let urlRequest = TheMovieDB.shared.getURLRequest(endpoint: "/discover/movie", parameters: parameters)
        var request = URLRequest(url: URL(string: urlRequest)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(TheMovieDB.DiscoverMovie.Response.self, from: data!)
                
                DispatchQueue.main.async {
                    completionHandler(responseModel)
                }
            } catch {
                print("JSON Serialization error")
                print(error)
            }
        }).resume()
    }
}