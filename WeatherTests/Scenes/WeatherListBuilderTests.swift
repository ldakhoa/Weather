//
//  WeatherListBuilderTests.swift
//  WeatherTests
//
//  Created by Khoa Le on 09/04/2022.
//

import Foundation
@testable import Weather
import XCTest

final class WeatherListBuilderTests: XCTestCase {
    private var sut: WeatherListBuilder!
    private var weatherListUseCase: WeatherListUseCase!
    
    override func setUpWithError() throws {
        sut = WeatherListBuilder()
        weatherListUseCase = SpyWeatherListUseCase()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        weatherListUseCase = nil
    }
    
    // MARK: - Test build
    
    func test_build() throws {
        let viewController = sut.build() as! WeatherListViewController
        let presenter = viewController.presenter as! WeatherListPresenter
        
        XCTAssertNotNil(viewController)
        XCTAssertIdentical(presenter.view, viewController)
    }
    
}
