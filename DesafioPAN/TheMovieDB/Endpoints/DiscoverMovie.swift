//
//  DiscoverMovie.swift
//  DesafioPAN
//
//  Created by Lucas Saito on 20/10/2018.
//  Copyright © 2018 Otias. All rights reserved.
//

import Foundation

extension TheMovieDB {
    enum DiscoverMovie {
        struct Request: Serializable {
            let language: String
            let sort_by: String
            let include_adult: Bool
            let include_video: Bool
            let page: Int
        }
        
        struct Response: Decodable {
            let page: Int?
            let results: [Movie]?
            let total_results: Int?
            let total_pages: Int?
        }
    }
}
