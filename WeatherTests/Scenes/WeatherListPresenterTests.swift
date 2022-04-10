//
//  WeatherListPresenterTests.swift
//  WeatherTests
//
//  Created by Khoa Le on 09/04/2022.
//

import XCTest
@testable import Weather

final class WeathListPresenterTests: XCTestCase {
    private var data: [Forecast]!
    private var view: SpyWeatherListViewable!
    private var sut: WeatherListPresenter!
    private var weatherListUseCase: SpyWeatherListUseCase!
    private var city: String!
    
    // MARK: - Life Cycle
    
    override func setUpWithError() throws {
        data = makeForecasts()
        view = SpyWeatherListViewable()
        weatherListUseCase = SpyWeatherListUseCase()
        weatherListUseCase.stubbedForecastsPromise = .success(makeForecasts())
        sut = WeatherListPresenter(weatherListUseCase: weatherListUseCase, degreeUnit: .metric)
        sut.view = view
        city = "Saigon"
    }
    
    override func tearDownWithError() throws {
        data = nil
        view = nil
        sut = nil
        weatherListUseCase = nil
        city = nil
    }
    
    // MARK: - Test Cases - init()
    
    func test_init() throws {
        XCTAssertIdentical(sut.weatherListUseCase as! SpyWeatherListUseCase, weatherListUseCase)
    }
    
    // MARK: - Test Cases - reloadData()
    
    func test_reloadData() throws {
        sut.reloadData(city: city, shouldShowLoading: true)
    }
    
    func test_handledReloadData() throws {
        XCTAssertFalse(weatherListUseCase.invokedForecasts)
        
        sut.reloadData(city: city, shouldShowLoading: true)
        
        XCTAssertFalse(sut.forecasts.isEmpty)

        XCTAssertTrue(weatherListUseCase.invokedForecasts)
        XCTAssertEqual(weatherListUseCase.invokedForecastsParameters?.keyword, "Saigon")
        XCTAssertEqual(weatherListUseCase.invokedForecastsParameters?.numberOfDays, 7)
        XCTAssertEqual(weatherListUseCase.invokedForecastsParameters?.degreeUnit, .metric)
    }
    
    // MARK: - Test Cases - numberOfSections()
    
    func test_numberOfSections() throws {
        XCTAssertEqual(sut.numberOfSections(), 1)
    }
    
    // MARK: - Test Cases - numberOfRows(in:)
    
    func test_numberOfRows() throws {
        XCTAssertEqual(sut.numberOfRows(in: 0), sut.forecasts.count)
        XCTAssertEqual(sut.numberOfRows(in: 1), 0)
    }
    
    // MARK: - Test Cases - didChangeValueRefreshControl()
    
    func test_didChangeValueRefreshControl() throws {
        sut.reloadData(shouldShowLoading: true)
        XCTAssertEqual(sut.forecasts, data)

        weatherListUseCase.stubbedForecastsPromise = .success(data)
        sut.didChangeValueRefreshControl()

        XCTAssertEqual(sut.forecasts.count, 3)
    }
    
    // MARK: - Test Cases - forecast(at:)
    
    func test_forecastAtIndexPath() throws {
        sut.reloadData(city: city, shouldShowLoading: true)
        XCTAssertTrue(weatherListUseCase.invokedForecasts)

        XCTAssertFalse(sut.forecasts.isEmpty)
        XCTAssertEqual(sut.forecasts(at: IndexPath(row: 0, section: 0)), data[0])
        XCTAssertEqual(sut.forecasts(at: IndexPath(row: 1, section: 0)), data[1])
    }
    
    // MARK: - Test Cases - searchForecasts(byCity:)
    
    func test_searchForecasts() throws {
        sut.searchForecasts(byCity: "Saigon")
        XCTAssertTrue(weatherListUseCase.invokedForecasts)
        XCTAssertFalse(sut.forecasts.isEmpty)
    }
    
    // MARK: - Test Cases - cleaup
    
    func test_cleanup() {
        sut.cleanup()
        XCTAssertTrue(sut.forecasts.isEmpty)
        XCTAssertTrue(view.invokedReloadData)
    }
}

extension WeathListPresenterTests {
    private func makeForecasts() -> [Forecast] {
        [.stubbed, .stubbed, .stubbed]
    }
}
