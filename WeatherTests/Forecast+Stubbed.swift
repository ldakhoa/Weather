//
//  Forecast+Stubbed.swift
//  WeatherTests
//
//  Created by Khoa Le on 09/04/2022.
//

import Foundation
import Weather

extension Forecast {
    static var stubbed: Forecast {
        let data = general.data(using: .utf8)!
        return try! JSONDecoder().decode(Forecast.self, from: data)
    }
}

fileprivate let general = """
    {
      "dt": 1649563200,
      "sunrise": 1649544306,
      "sunset": 1649588639,
      "temp": {
        "day": 33.14,
        "min": 25.17,
        "max": 34.01,
        "night": 26.75,
        "eve": 31.97,
        "morn": 25.17
      },
      "feels_like": {
        "day": 35.73,
        "night": 28.73,
        "eve": 35.58,
        "morn": 25.81
      },
      "pressure": 1010,
      "humidity": 47,
      "weather": [
        {
          "id": 500,
          "main": "Rain",
          "description": "light rain",
          "icon": "10d"
        }
      ],
      "speed": 5.44,
      "deg": 145,
      "gust": 8.21,
      "clouds": 44,
      "pop": 0.51,
      "rain": 1.67
    }
"""
