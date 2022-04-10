//
//  NetworkRequestableTests.swift
//  WeatherTests
//
//  Created by Khoa Le on 10/04/2022.
//

import XCTest
@testable import Weather

final class NetworkRequestableTests: XCTestCase {
    private var sut: NetworkRequestable!
    private let city = "saigon"
    
    override func setUpWithError() throws {
        sut = DefaultNetworkRequestable()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: - Test Cases - fetch(endPoint:)
    
    func test_fetchSuccess() {
        let expect = expectation(description: "test_fetchSaigon")
        var forecasts = [Forecast]()
        
        sut.fetch(endPoint: WeatherEndpoint.weather(city: city, numberOfDays: 7, degreeUnit: .default), type: ForecastResponse.self) { response in
            switch response {
            case let .success(data):
                forecasts = data.list
            case let .failure(error):
                XCTFail("Fetching data error \(error)")
            }
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectations error \(error)")
            } else {
                XCTAssertFalse(forecasts.isEmpty)
            }
        }
    }
    
    func test_networkEndpointError() {
        sut.fetch(endPoint: ErrorEndpoint.errorRequest, type: ForecastResponse.self) { response in
            switch response {
            case .success:
                XCTFail("Request should be failed")
            case let .failure(error):
                XCTAssertTrue(error.description == NetworkError.noSuccessResponse(code: "401").description)
            }
        }
    }
}
