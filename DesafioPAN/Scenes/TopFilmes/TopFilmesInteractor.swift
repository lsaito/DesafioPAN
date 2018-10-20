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

class TopFilmesInteractor: TopFilmesInteractorProtocol {
    var worker: TopFilmesWorker?
    var presenter: TopFilmesPresenterProtocol?
    
    func fetchTopFilmes(request: TopFilmes.DiscoverMovies.Request) {
        worker = TopFilmesWorker()
        worker?.fetchTopFilmes(request: request, completionHandler: { (filmes) in
            let response = filmes
            self.presenter?.presentFetchedTopFilmes(response: response)
        })
    }
}
