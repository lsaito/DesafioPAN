//
//  TopFilmesViewControllerTests.swift
//  DesafioPANTests
//
//  Created by Lucas Saito on 28/10/2018.
//  Copyright © 2018 Otias. All rights reserved.
//

@testable import DesafioPAN
import XCTest

class TopFilmesViewControllerTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: TopFilmesViewController!
    var window: UIWindow!
    
    // MARK: Test lifecycle

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        window = UIWindow()
        setupTopFilmesViewController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        window = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupTopFilmesViewController() {
        sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TopFilmesViewController") as? TopFilmesViewController
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: Test doubles
    
    class TopFilmesInteractorSpy: TopFilmesInteractorProtocol
    {
        // MARK: Method call expectations
        var fetchTopFilmesCalled = false
        var refreshDataCalled = false
        var searchFilmesCalled = false
        var endSearchCalled = false
        
        // MARK: Spied methods
        func fetchTopFilmes() {
            fetchTopFilmesCalled = true
        }
        func refreshData() {
            refreshDataCalled = true
            fetchTopFilmes()
        }
        func searchFilmes(request: TopFilmes.DiscoverMovies.Request) {
            searchFilmesCalled = true
        }
        func endSearch() {
            endSearchCalled = true
        }
    }
    
    // MARK: Tests
    
    func testShouldFetchTopFilmesWhenViewIsLoaded() {
        // Given
        let topFilmesInteractorSpy = TopFilmesInteractorSpy()
        sut.interactor = topFilmesInteractorSpy
        
        // When
        loadView()
        
        // Then
        XCTAssert(topFilmesInteractorSpy.fetchTopFilmesCalled, "Should fetch Top Filmes when the view is loaded")
    }
    
    func testTextFieldShouldReturnShouldAskInteractorToSearchFilmes() {
        // Given
        let topFilmesInteractorSpy = TopFilmesInteractorSpy()
        sut.interactor = topFilmesInteractorSpy
        
        // When
        let textField = UITextField()
        _ = sut.textFieldShouldReturn(textField)
        
        // Then
        XCTAssert(topFilmesInteractorSpy.searchFilmesCalled, "textFieldShouldReturn() should ask the interactor to search filmes")
    }
    
    func testTextFieldShouldClearShouldAskInteractorToEndSearch() {
        // Given
        let topFilmesInteractorSpy = TopFilmesInteractorSpy()
        sut.interactor = topFilmesInteractorSpy
        
        // When
        let textField = UITextField()
        _ = sut.textFieldShouldClear(textField)
        
        // Then
        XCTAssert(topFilmesInteractorSpy.endSearchCalled, "textFieldShouldClear() should ask the interactor to end search")
    }

}
