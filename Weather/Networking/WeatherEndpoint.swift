//
//  WeatherEndpoint.swift
//  Weather
//
//  Created by Khoa Le on 05/04/2022.
//

import Foundation

enum WeatherEndpoint {
    case weather(city: String, numberOfDays: Int, degreeUnit: DegreeUnit)
}

extension WeatherEndpoint: APIEndpoint {
    var path: String {
        "data/2.5/forecast/daily"
    }

    var headers: HTTPHeaders {
        return [:]
    }

    var method: HTTPMethod {
        .get
    }

    var parameters: Parameters? {
        switch self {
        case let .weather(city, numberOfDays, degreeUnit):
            return [
                "q": city,
                "cnt": numberOfDays,
                "appid": DefaultNetworkConfiguration.appID,
                "units": degreeUnit.rawValue
            ]
        }
    }
}
