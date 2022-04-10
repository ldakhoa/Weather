//
//  WeatherListUseCase.swift
//  Weather
//
//  Created by Khoa Le on 05/04/2022.
//

import Foundation

/// An object provides methods for interacting with the user data in the remote database.
///
/// The use cases situated on top of models and the “ports” for the data access layer (used for dependency inversion, usually Repository interfaces), retrieve and store domain models by using either repositories or other use cases.
protocol WeatherListUseCase {
    /// Get weather forecast list.
    /// - Parameters:
    ///   - keyword: The keyword that represent name of the city.
    ///   - numberOfDays: Number of forecast days.
    ///   - degreeUnit: The temperature unit.
    ///   - promise: A promise to be fulfilled with a result is the list of forecast.
    func forecasts(
        byKeyword keyword: String,
        numberOfDays: Int,
        degreeUnit: DegreeUnit,
        promise: @escaping (Result<[Forecast], NetworkError>) -> Void)
}

struct DefaultWeatherListUseCase: WeatherListUseCase {
    // MARK: - Dependencies

    /// An object provides methods for interacting with the user data in the remote database.
    let remoteWeatherListRepository: RemoteWeatherListRepository

    // MARK: - Init

    /// Initiate an use case that manages the weather data and apply business rules to achive a use case.
    /// - Parameter remoteWeatherListRepository: An object provides methods for interacting with the user data in the remote database.
    init(
        remoteWeatherListRepository: RemoteWeatherListRepository = DefaultRemoteWeatherListRepository()
    ) {
        self.remoteWeatherListRepository = remoteWeatherListRepository
    }

    // MARK: - WeatherListUseCase

    func forecasts(
        byKeyword keyword: String,
        numberOfDays: Int,
        degreeUnit: DegreeUnit,
        promise: @escaping (Result<[Forecast], NetworkError>) -> Void
    ) {
        remoteWeatherListRepository.weather(
            byKeyword: keyword,
            numberOfDays: numberOfDays,
            degreeUnit: degreeUnit,
            promise: promise)
    }
    
}
