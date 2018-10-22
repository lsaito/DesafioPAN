//
//  TopFilmesPresenter.swift
//  DesafioPAN
//
//  Created by Lucas Saito on 20/10/2018.
//  Copyright © 2018 Otias. All rights reserved.
//

import Foundation

protocol TopFilmesPresenterProtocol {
    func presentFetchedTopFilmes(response: TopFilmes.DiscoverMovies.Response)
}

class TopFilmesPresenter: TopFilmesPresenterProtocol {
    weak var viewController: TopFilmesViewControllerProtocol?
    
    func presentFetchedTopFilmes(response: TopFilmes.DiscoverMovies.Response) {
        var moviesCollection: [TopFilmes.MovieCollectionItem]? = []
        
        if let movies = response.moviesList {
            for movie in movies {
                let movieItem = TopFilmes.MovieCollectionItem.init(
                    imageURL: movie.imageURL,
                    title: movie.title
                )
                moviesCollection?.append(movieItem)
            }
        }
        
        let viewModel = TopFilmes.DiscoverMovies.ViewModel.init(moviesCollection: moviesCollection)
        viewController?.displayTopFilmes(viewModel: viewModel)
    }
}
