//
//  RemoteWeatherListRepository.swift
//  Weather
//
//  Created by Khoa Le on 05/04/2022.
//

import Foundation

/// An object provides methods for interacting with the user data in the remote database.
protocol RemoteWeatherListRepository {
    /// Get weather forecast list.
    /// - Parameters:
    ///   - keyword: The keyword that represent name of the city.
    ///   - numberOfDays: Number of forecast days.
    ///   - degreeUnit: The temperature unit.
    ///   - promise: A promise to be fulfilled with a result is the list of forecast.
    func weather(
        byKeyword keyword: String,
        numberOfDays: Int,
        degreeUnit: DegreeUnit,
        promise: @escaping (Result<[Forecast], NetworkError>) -> Void)
}

/// An object provides methods for interacting with the weather data in the remote database.
struct DefaultRemoteWeatherListRepository: RemoteWeatherListRepository {
    /// An object that responsibility of firing API call.
    private let networkClient: NetworkRequestable

    /// Initiate a repository that interact with the weather data in the remote database.
    /// - Parameter networkClient: An object that responsibility of firing API call.
    init(networkClient: NetworkRequestable = DefaultNetworkRequestable()) {
        self.networkClient = networkClient
    }

    // MARK: - RemoteWeatherListRepository

    func weather(
        byKeyword keyword: String,
        numberOfDays: Int,
        degreeUnit: DegreeUnit,
        promise: @escaping (Result<[Forecast], NetworkError>) -> Void
    ) {
        let endpoint: WeatherEndpoint = .weather(
            city: keyword,
            numberOfDays: numberOfDays,
            degreeUnit: degreeUnit)
        networkClient.fetch(
            endPoint: endpoint,
            type: ForecastResponse.self
        ) { result in
            switch result {
            case let .success(response):
                promise(.success(response.list))
            case let .failure(error):
                promise(.failure(error))
            }
        }
    }
}
