//
//  FilmeInteractor.swift
//  DesafioPAN
//
//  Created by Lucas Saito on 20/10/2018.
//  Copyright © 2018 Otias. All rights reserved.
//

import Foundation

protocol TopFilmesInteractorProtocol {
    func fetchTopFilmes(request: TopFilmes.DiscoverMovies.Request)
}

protocol TopFilmesDataStore {
    var currentPage: Int { get set }
}

class TopFilmesInteractor: TopFilmesInteractorProtocol, TopFilmesDataStore {
    var worker: TopFilmesWorker?
    var presenter: TopFilmesPresenterProtocol?
    var currentPage: Int = 0
    var moviesList: [TopFilmes.MovieListItem]? = []
    
    func fetchTopFilmes(request: TopFilmes.DiscoverMovies.Request) {
        let requestAPI = TheMovieDB.DiscoverMovie.Request.init(
            language: "en-US",
            sort_by: "popularity.desc",
            include_adult: false,
            include_video: false,
            page: currentPage + 1
        )
        
        worker = TopFilmesWorker()
        worker?.fetchDiscoverMovie(request: requestAPI, completionHandler: { (responseAPI) in
            if (self.currentPage + 1 == responseAPI.page) {
                self.currentPage = responseAPI.page!
                if let movies = responseAPI.results {
                    if let baseUrlImage = TheMovieDB.shared.configuration.images?.secure_base_url, let size = TheMovieDB.shared.configuration.images?.poster_sizes?.first {
                        for movie in movies {
                            let movieItem = TopFilmes.MovieListItem.init(
                                imageURL: baseUrlImage + size + (movie.poster_path ?? ""),
                                title: movie.title,
                                vote_count: movie.vote_count,
                                popularity: movie.popularity
                            )
                            self.moviesList?.append(movieItem)
                        }
                    }
                }
            }
            let response = TopFilmes.DiscoverMovies.Response.init(moviesList: self.moviesList)
            self.presenter?.presentFetchedTopFilmes(response: response)
        })
    }
}
