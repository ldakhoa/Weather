//
//  WeatherListCacheTests.swift
//  WeatherTests
//
//  Created by Khoa Le on 10/04/2022.
//

import XCTest
@testable import Weather

final class WeatherListCacheTests: XCTestCase {
    private var sut: WeatherListCache!
    private var forecasts: [Forecast]!
    
    override func setUpWithError() throws {
        sut = WeatherListCache()
        forecasts = [.stubbed, .stubbed, .stubbed]
    }
    
    override func tearDownWithError() throws {
        sut = nil
        forecasts = nil
    }
    
    // MARK: - Test Cases - add(:for:)
    
    func test_AddItem() {
        XCTAssertNotNil(sut)
        sut.add(forecasts, for: "saigon")
        XCTAssertNotNil(sut.forecasts(fromCity:"saigon"))
    }
    
    // MARK: - Test Cases - forecasts(fromCity:)
    
    func test_forecastsInvalidItem() {
        sut.add(forecasts, for: "saigon")
        XCTAssertNil(sut.forecasts(fromCity:"saigon2"))
    }
    
    // MARK: - Test Cases - clear()
    
    func test_cacheClear() {
        sut.add(forecasts, for: "saigon")
        sut.clear()
        XCTAssertNil(sut.forecasts(fromCity:"saigon"))
    }
}
