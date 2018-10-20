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
        let viewModel = TopFilmes.DiscoverMovies.ViewModel()
        viewController?.displayTopFilmes(viewModel: viewModel)
    }
}
