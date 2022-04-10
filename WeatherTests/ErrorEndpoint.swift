//
//  ErrorEndpoint.swift
//  WeatherTests
//
//  Created by Khoa Le on 10/04/2022.
//

import Foundation
@testable import Weather

enum ErrorEndpoint {
    case errorRequest
}

extension ErrorEndpoint: APIEndpoint {
    var path: String {
        "data/2.5/forecast/dailyError"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var parameters: Parameters? {
        nil
    }
}
