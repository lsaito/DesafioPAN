//
//  TopFilmesWorkerTests.swift
//  DesafioPANTests
//
//  Created by Lucas Saito on 28/10/2018.
//  Copyright © 2018 Otias. All rights reserved.
//

@testable import DesafioPAN
import XCTest

class TopFilmesWorkerTests: XCTestCase {
    // MARK: - Subject under test
    
    var sut: TopFilmesWorker!
    
    // MARK: - Test lifecycle

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        setupTopFilmesWorker()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupTopFilmesWorker() {
        sut = TopFilmesWorker()
    }
    
    // MARK: Tests
    
    func testFetchTopFilmesShouldReturnListOfMovies() {
        // Given
        let promise = expectation(description: "Wait for fetchDiscoverMovie() to return")
        var responseData: TheMovieDB.DiscoverMovie.Response?
        var responseError: Error?
        
        // When
        let request = TheMovieDB.DiscoverMovie.Request.init(
            language: "en-US",
            sort_by: "popularity.desc",
            include_adult: false,
            include_video: false,
            page: 1
        )
        sut.fetchDiscoverMovie(request: request, completionSuccess: { (response) in
            responseData = response
            promise.fulfill()
        }, completionError: { (error) in
            responseError = error
            promise.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        
        // Then
        XCTAssertNil(responseError)
        XCTAssertGreaterThan(responseData?.results?.count ?? 0, 0, "fetchDiscoverMovie() should return a list of movies")
    }

}
