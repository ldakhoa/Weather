//
//  SpyWeatherListPresentable.swift
//  WeatherTests
//
//  Created by Khoa Le on 09/04/2022.
//

import Foundation
@testable import Weather

final class SpyWeatherListPresentable: WeatherListPresentable {
    
    var invokedViewWillAppear = false
    var invokedViewWillAppearCount = 0
    
    func viewWillAppear() {
        invokedViewWillAppear = true
        invokedViewWillAppearCount += 1
    }
    
    var invokedNumberOfSections = false
    var invokedNumberOfSectionsCount = 0
    var stubbedNumberOfSectionsResult: Int! = 0
    
    func numberOfSections() -> Int {
        invokedNumberOfSections = true
        invokedNumberOfSectionsCount += 1
        return stubbedNumberOfSectionsResult
    }
    
    var invokedNumberOfRows = false
    var invokedNumberOfRowsCount = 0
    var invokedNumberOfRowsParameters: (section: Int, Void)?
    var invokedNumberOfRowsParametersList = [(section: Int, Void)]()
    var stubbedNumberOfRowsResult: Int! = 0
    
    func numberOfRows(in section: Int) -> Int {
        invokedNumberOfRows = true
        invokedNumberOfRowsCount += 1
        invokedNumberOfRowsParameters = (section, ())
        invokedNumberOfRowsParametersList.append((section, ()))
        return stubbedNumberOfRowsResult
    }
    
    var invokedForecast = false
    var invokedForecastCount = 0
    var stubbedForecastResult: Forecast!
    
    func forecasts(at indexPath: IndexPath) -> Forecast {
        invokedForecast = true
        invokedForecastCount += 1
        return stubbedForecastResult
    }
    
    var invokedDidChangeValueRefreshControl = false
    var invokedDidChangeValueRefreshControlCount = 0
    
    func didChangeValueRefreshControl() {
        invokedDidChangeValueRefreshControl = true
        invokedDidChangeValueRefreshControlCount += 1
    }
    
    var invokedSearchForecast = false
    var invokedSearchForecastCount = 0
    
    func searchForecasts(byCity city: String) {
        invokedSearchForecast = true
        invokedSearchForecastCount += 1
    }
    
    var invokedCleanup = false
    var invokedCleanupCount = 0
    
    func cleanup() {
        invokedCleanup = true
        invokedCleanupCount += 1
    }
    
    var invokedDegreeUnit = false
    var invokedDegreeUnitCount = 0
    var stubbedDegreeUnit: DegreeUnit = .metric
    
    var degreeUnit: DegreeUnit {
        invokedDegreeUnit = true
        invokedDegreeUnitCount += 1
        return stubbedDegreeUnit
    }
}
