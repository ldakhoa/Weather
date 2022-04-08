//
//  Forecast.swift
//  Weather
//
//  Created by Khoa Le on 05/04/2022.
//

import Foundation

public struct Forecast: Decodable {
    let dateTime: Double
    let temperature: Temperature
    let pressure: Int
    let humidity: Int
    let weather: [Weather]
    let speed: Float

    private enum CodingKeys: String, CodingKey {
        case dateTime = "dt", temperature = "temp", pressure, humidity, weather, speed
    }
}

struct ForecastResponse: Decodable {
    let city: City
    let cnt: Int
    let list: [Forecast]
}
