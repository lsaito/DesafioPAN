//
//  Repository.swift
//  DesafioPAN
//
//  Created by Lucas Saito on 18/10/2018.
//  Copyright © 2018 Otias. All rights reserved.
//

import Foundation

class Repository {
    static let baseURL = "https://api.themoviedb.org/3"
    static let api_key = "271253d65cac98d5079059c725fed688"
    
    static func getURLRequest(endpoint: String, parameters: [String: Any]? = [:]) -> String {
        var URLRequest = ""
        
        URLRequest.append(contentsOf: baseURL)
        URLRequest.append(contentsOf: endpoint)
        URLRequest.append(contentsOf: "?api_key=")
        URLRequest.append(contentsOf: api_key)
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
}
