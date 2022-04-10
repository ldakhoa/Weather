//
//  Forecast.swift
//  Weather
//
//  Created by Khoa Le on 05/04/2022.
//

import Foundation

public struct Forecast: Decodable, Equatable {
    let dateTime: Double
    let temperature: Temperature
    let pressure: Int
    let humidity: Int
    let weather: [Weather]
    let speed: Float

    private enum CodingKeys: String, CodingKey {
        case dateTime = "dt"
        case temperature = "temp"
        case pressure, humidity, weather, speed
    }
    
    public static func == (lhs: Forecast, rhs: Forecast) -> Bool {
        lhs.dateTime == rhs.dateTime &&
        lhs.pressure == rhs.pressure &&
        lhs.humidity == rhs.humidity &&
        lhs.speed == rhs.speed
    }
}

public struct ForecastResponse: Decodable {
    public let city: City
    public let cnt: Int
    public let list: [Forecast]
}
