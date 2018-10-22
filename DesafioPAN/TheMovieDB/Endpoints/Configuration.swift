//
//  Configuration.swift
//  DesafioPAN
//
//  Created by Lucas Saito on 21/10/2018.
//  Copyright © 2018 Otias. All rights reserved.
//

import Foundation

extension TheMovieDB {
    enum Configuration {
        struct Request {
            
        }
        
        struct Response: Decodable {
            let images: Images?
            let change_keys: [String]?
        }
    }
}

struct Images: Decodable {
    let base_url: String?
    let secure_base_url: String?
    let backdrop_sizes: [String]?
    let logo_sizes: [String]?
    let poster_sizes: [String]?
    let profile_sizes: [String]?
    let still_sizes: [String]?
}
