//
//  Repository.swift
//  DesafioPAN
//
//  Created by Lucas Saito on 18/10/2018.
//  Copyright © 2018 Otias. All rights reserved.
//

import Foundation

class TheMovieDB {
    static let shared = TheMovieDB()
    
    let baseURL = "https://api.themoviedb.org/3"
    let api_key = "271253d65cac98d5079059c725fed688"
    var configuration: TheMovieDB.Configuration.Response!
    
    private init() {
        self.fetchConfiguration(request: TheMovieDB.Configuration.Request()) { (response) in
            self.configuration = response
        }
    }
    
    func getURLRequest(endpoint: String, parameters: [String: Any]? = [:]) -> String {
        var URLRequest = ""
        
        URLRequest.append(contentsOf: self.baseURL)
        URLRequest.append(contentsOf: endpoint)
        URLRequest.append(contentsOf: "?api_key=")
        URLRequest.append(contentsOf: self.api_key)
        URLRequest.append(contentsOf: "&")
        
        if let parametersFormattedString = parameters?.reduce(into: String(), { (params, arg1) in
            let (key, value) = arg1
            var valueCast: String = ""
            if let valueStr = value as? String {
                valueCast = valueStr
            } else if let valueInt = value as? Int {
                valueCast = String(valueInt)
            } else if let valueBool = value as? Bool {
                valueCast = String(valueBool)
            }
            params += "&" + key + "=" + valueCast
        }) {
            URLRequest.append(contentsOf: parametersFormattedString)
        }
        
        return URLRequest
    }
    
    func fetchConfiguration(request: TheMovieDB.Configuration.Request, completionHandler: @escaping (TheMovieDB.Configuration.Response) -> Void)
    {
        let urlRequest = self.getURLRequest(endpoint: "/configuration")
        var request = URLRequest(url: URL(string: urlRequest)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(TheMovieDB.Configuration.Response.self, from: data!)
                
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
