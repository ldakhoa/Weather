//
//  WeatherListTableViewCellTests.swift
//  WeatherTests
//
//  Created by Khoa Le on 09/04/2022.
//

import XCTest
@testable import Weather

final class WeatherListTableViewCellTests: XCTestCase {
    private var forecast: Forecast!
    private var sut: WeatherListTableViewCell!
    
    override func setUpWithError() throws {
        forecast = .stubbed
        sut = WeatherListTableViewCell()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        forecast = nil
    }
    
    // MARK: - Test Case - init(style:reuseIdentifier:)
    
    func test_initWithFrame() throws {
        [sut.dateLabel, sut.averageTemperatureLabel, sut.pressureLabel, sut.humidityLabel, sut.descriptionLabel].forEach {
            XCTAssertTrue(sut.stackView.arrangedSubviews.contains($0))
        }
        XCTAssertTrue(sut.stackView.isDescendant(of: sut))
        XCTAssertEqual(sut.stackView.axis, .vertical)
    }
    
    // MARK: - Test Case - update(withForecast:unit:)
    
    func test_update() {
        sut.update(withForecast: forecast, unit: .metric)
        let avgTemperature = Int(forecast.temperature.min + forecast.temperature.max) / 2
        
        XCTAssertEqual(sut.averageTemperatureLabel.text, "Average Temperature: \(avgTemperature)°C")
        
        sut.update(withForecast: forecast, unit: .default)
        XCTAssertEqual(sut.averageTemperatureLabel.text, "Average Temperature: \(avgTemperature)°K")
        
        sut.update(withForecast: forecast, unit: .imperial)
        XCTAssertEqual(sut.averageTemperatureLabel.text, "Average Temperature: \(avgTemperature)°F")
    }
}
