//
//  WeatherListViewControllerTests.swift
//  WeatherTests
//
//  Created by Khoa Le on 09/04/2022.
//

import XCTest
@testable import Weather

final class WeatherListViewControllerTests: XCTestCase {
    private var presenter: SpyWeatherListPresentable!
    private var sut: WeatherListViewController!
    
    // MARK: - Life Cycle
    
    override func setUpWithError() throws {
        presenter = SpyWeatherListPresentable()
        sut = WeatherListViewController(presenter: presenter)
        sut.loadViewIfNeeded()
    }
    
    override func tearDownWithError() throws {
        presenter = nil
        sut = nil
    }
    
    // MARK: - Test Cases - init(presenter:)
    
    func test_initWithPresenter() throws {
        XCTAssertIdentical(sut.presenter as? SpyWeatherListPresentable, presenter)
        
        XCTAssertTrue(sut.loadingView.isHidden)
        XCTAssertTrue(sut.statefulView.isHidden)
        
        XCTAssertIdentical(sut.tableView.dataSource, sut)
        XCTAssertIdentical(sut.tableView.delegate, sut)
    }
    
    // MARK: - Test Cases - loadView()
    
    func test_loadView() throws {
        XCTAssertTrue(sut.loadingView.isDescendant(of: sut.view))
        XCTAssertTrue(sut.tableView.isDescendant(of: sut.view))
        XCTAssertTrue(sut.statefulView.isDescendant(of: sut.view))
    }
    
    // MARK: - Test Cases - viewWillAppear()
    
    func test_viewWillAppear() throws {
        XCTAssertFalse(presenter.invokedViewWillAppear)
        sut.viewWillAppear(false)
        XCTAssertTrue(presenter.invokedViewWillAppear)
    }
    
    // MARK: - Test Cases - toggleLoading(_:)
    
    func test_toggleLoading() throws {
        XCTAssertTrue(sut.loadingView.isHidden)
        
        sut.toggleLoading(true)
        
        XCTAssertFalse(sut.loadingView.isHidden)
        
        sut.toggleLoading(false)
        
        XCTAssertTrue(sut.loadingView.isHidden)
    }
    
    // MARK: - Test Cases - toggleStatefulView()
    
    func test_toggleStatefulView() throws {
        sut.toggleStatefulView(withState: .onHide)
        XCTAssertTrue(sut.statefulView.isHidden)
        
        sut.toggleStatefulView(withState: .findCity)
        XCTAssertFalse(sut.statefulView.isHidden)
        
        sut.toggleStatefulView(withState: .tryAgain)
        XCTAssertFalse(sut.statefulView.isHidden)
    }
    
    // MARK: - Test Cases - showAlert
    
    func test_showAlert() throws {
        let nav = UINavigationController(rootViewController: sut)
        sut.showAlert(withTitle: "")
        let exp = expectation(description: "Test show alert after 1.5 second wait")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.5)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertNotNil(nav.visibleViewController is UIAlertController)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    // MARK: - Test Cases - numberOfSections(in:)
    
    func test_numberOfSections() throws {
        presenter.stubbedNumberOfSectionsResult = 1
        XCTAssertFalse(presenter.invokedNumberOfSections)
        XCTAssertEqual(
            sut.numberOfSections(in: sut.tableView),
            presenter.stubbedNumberOfSectionsResult)
        XCTAssertTrue(presenter.invokedNumberOfSections)
    }
    
    // MARK: - Test Cases - numberOfRowsInSection()
    
    func test_numberOfRowsInSection() throws {
        presenter.stubbedNumberOfRowsResult = 1
        XCTAssertFalse(presenter.invokedNumberOfRows)
        
        XCTAssertEqual(
            sut.tableView(sut.tableView, numberOfRowsInSection: 0),
            presenter.stubbedNumberOfRowsResult)
    }
    
    // MARK: - Test Cases - smallerThanThreeWords
    
    func test_searchForecasts_smallerThanThreeWords() throws {
        let searchBar = sut.searchController.searchBar
        searchBar.text = "Sa"
        sut.handleSearchForecast(searchBar)
        XCTAssertFalse(presenter.invokedSearchForecast)
        
        searchBar.text = "S"
        sut.handleSearchForecast(searchBar)
        XCTAssertFalse(presenter.invokedSearchForecast)
        
        searchBar.text = ""
        sut.handleSearchForecast(searchBar)
        XCTAssertFalse(presenter.invokedSearchForecast)
        
        searchBar.text = "Sai"
        sut.handleSearchForecast(searchBar)
        XCTAssertTrue(presenter.invokedSearchForecast)
    }
}
