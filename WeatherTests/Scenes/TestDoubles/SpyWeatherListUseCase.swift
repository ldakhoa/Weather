//
//  SpyWeatherListUseCase.swift
//  WeatherTests
//
//  Created by Khoa Le on 10/04/2022.
//

import Foundation
@testable import Weather

final class SpyWeatherListUseCase: WeatherListUseCase {
    var callCompletionHandlerImmediate = true
    
    var invokedForecasts = false
    var invokedForecastsCount = 0
    var invokedForecastsParameters: (keyword: String, numberOfDays: Int, degreeUnit: DegreeUnit)?
    var invokedForecastsParametersList = [(keyword: String, numberOfDays: Int, degreeUnit: DegreeUnit)]()
    var stubbedForecastsPromise: Result<[Forecast], NetworkError>!
    
    func forecasts(byKeyword keyword: String, numberOfDays: Int, degreeUnit: DegreeUnit, promise: @escaping (Result<[Forecast], NetworkError>) -> Void) {
        invokedForecasts = true
        invokedForecastsCount += 1
        invokedForecastsParameters = (keyword, numberOfDays, degreeUnit)
        invokedForecastsParametersList.append((keyword, numberOfDays, degreeUnit))
        promise(stubbedForecastsPromise)
    }
}
