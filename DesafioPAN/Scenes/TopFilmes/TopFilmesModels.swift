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
        struct Request {
            let isRefresh: Bool?
        }
        
        struct Response {
            let isRefresh: Bool?
            let moviesList: [Movie]?
        }
        
        struct ViewModel {
            let isRefresh: Bool?
            let moviesCollection: [TopFilmes.MovieCollectionItem]?
        }
    }
    
    struct MovieCollectionItem {
        let imageURL: String?
        let title: String?
    }
}
