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
            
        }
        
        struct Response {
            let moviesList: [TopFilmes.MovieListItem]?
        }
        
        struct ViewModel {
            let moviesCollection: [TopFilmes.MovieCollectionItem]?
        }
    }
    
    struct MovieListItem {
        let imageURL: String?
        let title: String?
        let vote_count: Int?
        let popularity: Double?
    }
    
    struct MovieCollectionItem {
        let imageURL: String?
        let title: String?
    }
}
