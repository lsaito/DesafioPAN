//
//  TopFilmesModels.swift
//  DesafioPAN
//
//  Created by Lucas Saito on 20/10/2018.
//  Copyright © 2018 Otias. All rights reserved.
//

import Foundation

enum TopFilmes {
    enum DiscoverMovies {
        struct Request: Serializable {
            var language: String
            var sort_by: String
            var include_adult: Bool
            var include_video: Bool
            var page: Int
        }
        
        struct Response: Decodable {
            let page: Int?
            let results: [Movie]?
            let total_results: Int?
            let total_pages: Int?
        }
        
        struct ViewModel {
            
        }
    }
}
