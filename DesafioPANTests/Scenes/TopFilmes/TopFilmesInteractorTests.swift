//
//  TopFilmesInteractorTests.swift
//  DesafioPANTests
//
//  Created by Lucas Saito on 28/10/2018.
//  Copyright © 2018 Otias. All rights reserved.
//

@testable import DesafioPAN
import XCTest

class TopFilmesInteractorTests: XCTestCase {
    // MARK: - Subject under test
    
    var sut: TopFilmesInteractor!
    
    // MARK: Test lifecycle

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        setupTopFilmesInteractor()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupTopFilmesInteractor() {
        sut = TopFilmesInteractor()
    }
    
    // MARK: Test doubles
    
    class TopFilmesWorkerSpy: TopFilmesWorker {
        // MARK: Method call expectations
        
        var fetchDiscoverMovieCalled = false
        
        // MARK: Spied methods
        override func fetchDiscoverMovie(request: TheMovieDB.DiscoverMovie.Request, completionSuccess: @escaping (TheMovieDB.DiscoverMovie.Response) -> Void, completionError: @escaping (Error) -> Void) {
            fetchDiscoverMovieCalled = true
            if let path = Bundle.main.path(forResource: "DiscoverMovieResponseExample", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try jsonDecoder.decode(TheMovieDB.DiscoverMovie.Response.self, from: data)
                    
                    completionSuccess(responseModel)
                } catch {
                    print("JSON Serialization error")
                    completionError(error)
                }
            }
        }
    }
    
    class TopFilmesPresenterSpy: TopFilmesPresenterProtocol {
        // MARK: Method call expectations
        var presentFetchedTopFilmesCalled = false
        var presentOfflineMessageCalled = false
        var hideOfflineMessageCalled = false
        var endRefreshDataCalled = false
        
        // MARK: Spied methods
        func presentFetchedTopFilmes(response: TopFilmes.DiscoverMovies.Response) {
            presentFetchedTopFilmesCalled = true
        }
        func presentOfflineMessage() {
            presentOfflineMessageCalled = true
        }
        func hideOfflineMessage() {
            hideOfflineMessageCalled = true
        }
        func endRefreshData() {
            endRefreshDataCalled = true
        }
    }
    
    // MARK: Tests
    
    func testFetchTopMoviesShouldAskTopFilmesWorkerToFetchDiscoverMoviesAndPresenterToFormatResult() {
        // Given
        let topFilmesPresenterSpy = TopFilmesPresenterSpy()
        sut.presenter = topFilmesPresenterSpy
        let topFilmesWorkerSpy = TopFilmesWorkerSpy()
        sut.worker = topFilmesWorkerSpy

        // When
        sut.fetchTopFilmes()

        // Then
        XCTAssert(topFilmesWorkerSpy.fetchDiscoverMovieCalled, "fetchTopFilmes() should ask TopFilmesWorker to fetch DiscoverMovie")
        XCTAssert(topFilmesPresenterSpy.presentFetchedTopFilmesCalled, "fetchTopFilmes() should ask the presenter to format the result")
    }
    
    func testRefreshDataShouldAskTopFilmesWorkerToFetchDiscoverMoviesAndPresenterToFormatResultAndEndRefreshData() {
        // Given
        let topFilmesPresenterSpy = TopFilmesPresenterSpy()
        sut.presenter = topFilmesPresenterSpy
        let topFilmesWorkerSpy = TopFilmesWorkerSpy()
        sut.worker = topFilmesWorkerSpy
        
        // When
        sut.refreshData()
        
        // Then
        XCTAssert(topFilmesWorkerSpy.fetchDiscoverMovieCalled, "refreshData() should ask TopFilmesWorker to fetch DiscoverMovie")
        XCTAssert(topFilmesPresenterSpy.presentFetchedTopFilmesCalled, "refreshData() should ask the presenter to format the result")
        XCTAssert(topFilmesPresenterSpy.endRefreshDataCalled, "refreshData() should ask the presenter to end the refreshData")
    }
    
    func testSearchFilmesShouldAskTopFilmesPresenterToFormatResult() {
        // Given
        let topFilmesPresenterSpy = TopFilmesPresenterSpy()
        sut.presenter = topFilmesPresenterSpy
        
        // When
        let request = TopFilmes.DiscoverMovies.Request.init(searchString: "teste")
        sut.searchFilmes(request: request)
        
        // Then
        XCTAssert(topFilmesPresenterSpy.presentFetchedTopFilmesCalled, "searchFilmes(request:) should ask the presenter to format the result")
    }
    
    func testEndSearchShouldAskTopFilmesPresenterToFormatResult() {
        // Given
        let topFilmesPresenterSpy = TopFilmesPresenterSpy()
        sut.presenter = topFilmesPresenterSpy
        
        // When
        sut.endSearch()
        
        // Then
        XCTAssert(topFilmesPresenterSpy.presentFetchedTopFilmesCalled, "endSearch() should ask the presenter to format the result")
    }
}
