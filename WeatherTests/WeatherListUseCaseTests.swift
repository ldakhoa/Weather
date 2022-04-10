//
//  WeatherListUseCaseTests.swift
//  WeatherTests
//
//  Created by Khoa Le on 11/04/2022.
//

import XCTest
@testable import Weather

final class WeatherListUseCaseTests: XCTestCase {
    private var sut: WeatherListUseCase!
    private let keyword = "Saigon"
    
    override func setUpWithError() throws {
        sut = DefaultWeatherListUseCase()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: - Test Cases - forecasts(byKeyword:numberOfDays:degreeUnit)
    
    func test_forecasts() {
        sut.forecasts(byKeyword: keyword, numberOfDays: 7, degreeUnit: .default) { result in
            switch result {
            case let .success(forecasts):
                XCTAssertEqual(forecasts.count, 7)
            case let .failure(error):
                XCTFail("Fail to fetch weather \(error)")
            }
        }
    }
    
    func test_forecasts_emptyKeyword() {
        sut.forecasts(byKeyword: "", numberOfDays: 7, degreeUnit: .default) { result in
            switch result {
            case let .success(forecasts):
                XCTAssertFalse(forecasts.isEmpty)
            case let .failure(error):
                XCTAssertEqual(error.description, NetworkError.noSuccessResponse(code: "400").description)
            }
        }
    }
}
