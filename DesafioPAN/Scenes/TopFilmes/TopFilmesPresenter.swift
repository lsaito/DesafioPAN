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
    func presentOfflineMessage()
    func hideOfflineMessage()
    func endRefreshData()
}

class TopFilmesPresenter: TopFilmesPresenterProtocol {
    weak var viewController: TopFilmesViewControllerProtocol?
    
    func presentFetchedTopFilmes(response: TopFilmes.DiscoverMovies.Response) {
        var moviesCollection: [TopFilmes.MovieCollectionItem]? = []
        
        if let movies = response.moviesList {
            TheMovieDB.shared.getConfiguration(completionHandler: { (configuration) in
                if let configImg = configuration.images, let baseUrlImage = configImg.secure_base_url, let sizes = configImg.poster_sizes, let size = sizes.first {
                    for movie in movies {
                        let movieItem = TopFilmes.MovieCollectionItem.init(
                            imageURL: baseUrlImage + size + (movie.poster_path ?? ""),
                            title: movie.title
                        )
                        moviesCollection?.append(movieItem)
                    }
                    let viewModel = TopFilmes.DiscoverMovies.ViewModel.init(moviesCollection: moviesCollection)
                    self.viewController?.displayTopFilmes(viewModel: viewModel)
                }
            })
        }
    }
    func presentOfflineMessage() {
        viewController?.displayOfflineMessage()
    }
    func hideOfflineMessage() {
        viewController?.hideOfflineMessage()
    }
    func endRefreshData() {
        viewController?.endRefreshData()
    }
}
