//
//  FilmeInteractor.swift
//  DesafioPAN
//
//  Created by Lucas Saito on 20/10/2018.
//  Copyright © 2018 Otias. All rights reserved.
//

import Foundation
import UIKit
import CoreData

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
        worker?.fetchDiscoverMovie(
            request: requestAPI,
            completionSuccess: { (responseAPI) in
                if (self.currentPage == 0) {
                    self.removeAllLocalMovies()
                }
                if (self.currentPage + 1 == responseAPI.page) {
                    self.currentPage = responseAPI.page!
                    if let movies = responseAPI.results {
                        self.saveLocalMovies(movies: movies)
                        self.moviesList?.append(contentsOf: movies)
                    }
                }
                let response = TopFilmes.DiscoverMovies.Response.init(isRefresh: request.isRefresh, moviesList: self.moviesList)
                DispatchQueue.main.async {
                    self.presenter?.presentFetchedTopFilmes(response: response)
                }
            },
            completionError: { (responseError) in
                if let nsError: NSError = responseError as NSError? , nsError.code == -1009 {
                    DispatchQueue.main.async {
                        let response = TopFilmes.DiscoverMovies.Response.init(isRefresh: request.isRefresh, moviesList: self.getAllLocalMovies())
                        self.presenter?.presentOfflineTopFilmes(response: response)
                    }
                }
            }
        )
    }
    
    func refreshData(request: TopFilmes.DiscoverMovies.Request) {
        self.currentPage = 0
        self.moviesList?.removeAll()
        
        self.fetchTopFilmes(request: request)
    }
    
    private func saveLocalMovies(movies: [Movie]) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Movie", in: context)
        
        for movie in movies {
            let newMovie = NSManagedObject(entity: entity!, insertInto: context)
            newMovie.setValue(movie.poster_path, forKey: "poster_path")
            newMovie.setValue(movie.adult, forKey: "adult")
            newMovie.setValue(movie.overview, forKey: "overview")
            newMovie.setValue(movie.release_date, forKey: "release_date")
            newMovie.setValue(movie.genre_ids, forKey: "genre_ids")
            newMovie.setValue(movie.id, forKey: "id")
            newMovie.setValue(movie.original_title, forKey: "original_title")
            newMovie.setValue(movie.original_language, forKey: "original_language")
            newMovie.setValue(movie.title, forKey: "title")
            newMovie.setValue(movie.backdrop_path, forKey: "backdrop_path")
            newMovie.setValue(movie.popularity, forKey: "popularity")
            newMovie.setValue(movie.vote_count, forKey: "vote_count")
            newMovie.setValue(movie.video, forKey: "video")
            newMovie.setValue(movie.vote_average, forKey: "vote_average")
        }
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    private func removeAllLocalMovies() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for movie in result as! [NSManagedObject] {
                context.delete(movie)
            }
        } catch {
            print("Failed")
        }
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    private func getAllLocalMovies() -> [Movie]? {
        var movies: [Movie]? = []
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let movie = Movie.init(
                    poster_path: data.value(forKey: "poster_path") as? String,
                    adult: data.value(forKey: "adult") as? Bool,
                    overview: data.value(forKey: "overview") as? String,
                    release_date: data.value(forKey: "release_date") as? String,
                    genre_ids: data.value(forKey: "genre_ids") as? [Int],
                    id: data.value(forKey: "id") as? Int,
                    original_title: data.value(forKey: "original_title") as? String,
                    original_language: data.value(forKey: "original_language") as? String,
                    title: data.value(forKey: "title") as? String,
                    backdrop_path: data.value(forKey: "backdrop_path") as? String,
                    popularity: data.value(forKey: "popularity") as? Double,
                    vote_count: data.value(forKey: "vote_count") as? Int,
                    video: data.value(forKey: "video") as? Bool,
                    vote_average: data.value(forKey: "vote_average") as? Double
                )
                movies?.append(movie)
            }
        } catch {
            print("Failed")
        }
        
        return movies
    }
}
