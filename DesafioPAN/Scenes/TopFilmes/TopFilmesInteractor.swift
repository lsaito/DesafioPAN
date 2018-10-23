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
    func refreshData(request: TopFilmes.DiscoverMovies.Request)
}

protocol TopFilmesDataStore {
    var currentPage: Int { get set }
}

class TopFilmesInteractor: TopFilmesInteractorProtocol, TopFilmesDataStore {
    var worker: TopFilmesWorker?
    var presenter: TopFilmesPresenterProtocol?
    var currentPage: Int = 0
    var moviesList: [Movie]? = []
    
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
                    self.moviesList?.append(contentsOf: movies)
                }
            }
            let response = TopFilmes.DiscoverMovies.Response.init(isRefresh: request.isRefresh, moviesList: self.moviesList)
            self.presenter?.presentFetchedTopFilmes(response: response)
        })
    }
    
    func refreshData(request: TopFilmes.DiscoverMovies.Request) {
        self.currentPage = 0
        self.moviesList = []
        
        self.fetchTopFilmes(request: request)
    }
}
