//
//  TopFilmesPresenterTests.swift
//  DesafioPANTests
//
//  Created by Lucas Saito on 28/10/2018.
//  Copyright © 2018 Otias. All rights reserved.
//

@testable import DesafioPAN
import XCTest

class TopFilmesPresenterTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: TopFilmesPresenter!
    
    // MARK: Test lifecycle

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        setupTopFilmesPresenter()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupTopFilmesPresenter() {
        sut = TopFilmesPresenter()
    }
    
    // MARK: Test doubles
    
    class TopFilmesViewControllerSpy: TopFilmesViewControllerProtocol {
        // MARK: Method call expectations
        var displayTopFilmesCalled = false
        var displayOfflineMessageCalled = false
        var hideOfflineMessageCalled = false
        var endRefreshDataCalled = false
        
        // MARK: Argument expectations
        var viewModel: TopFilmes.DiscoverMovies.ViewModel!
        
        // MARK: Spied methods
        func displayTopFilmes(viewModel: TopFilmes.DiscoverMovies.ViewModel) {
            displayTopFilmesCalled = true
            self.viewModel = viewModel
        }
        func displayOfflineMessage() {
            displayOfflineMessageCalled = true
        }
        func hideOfflineMessage() {
            hideOfflineMessageCalled = true
        }
        func endRefreshData() {
            endRefreshDataCalled = true
        }
    }
    
    // MARK: Tests
    
    func testPresentFetchedTopFilmesShouldAskViewControllerToDisplayFetchedTopFilmes() {
        // Given
        let topFilmesViewControllerSpy = TopFilmesViewControllerSpy()
        sut.viewController = topFilmesViewControllerSpy
        
        // When
        if let path = Bundle.main.path(forResource: "DiscoverMovieResponseExample", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(TheMovieDB.DiscoverMovie.Response.self, from: data)
                
                let response = TopFilmes.DiscoverMovies.Response.init(moviesList: responseModel.results)
                sut.presentFetchedTopFilmes(response: response)
            } catch {
                print("JSON Serialization error")
            }
        }
        
        // Then
        XCTAssertTrue(topFilmesViewControllerSpy.displayTopFilmesCalled, "presentFetchedTopFilmes(response:) should ask the view controller to display the result")
    }
    
    func testPresentOfflineMessageShouldAskViewControllerToDisplayOfflineMessage() {
        // Given
        let topFilmesViewControllerSpy = TopFilmesViewControllerSpy()
        sut.viewController = topFilmesViewControllerSpy
        
        // When
        sut.presentOfflineMessage()
        
        // Then
        XCTAssertTrue(topFilmesViewControllerSpy.displayOfflineMessageCalled, "presentOfflineMessage() should ask the view controller to display the offlineMessage")
    }
    
    func testHideOfflineMessageShouldAskViewControllerToHideOfflineMessage() {
        // Given
        let topFilmesViewControllerSpy = TopFilmesViewControllerSpy()
        sut.viewController = topFilmesViewControllerSpy
        
        // When
        sut.hideOfflineMessage()
        
        // Then
        XCTAssertTrue(topFilmesViewControllerSpy.hideOfflineMessageCalled, "hideOfflineMessage() should ask the view controller to hide the offlineMessage")
    }
    
    func testEndRefreshDataShouldAskViewControllerToEndRefreshData() {
        // Given
        let topFilmesViewControllerSpy = TopFilmesViewControllerSpy()
        sut.viewController = topFilmesViewControllerSpy
        
        // When
        sut.endRefreshData()
        
        // Then
        XCTAssertTrue(topFilmesViewControllerSpy.endRefreshDataCalled, "endRefreshData() should ask the view controller to endRefreshData")
    }

}
