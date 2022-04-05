//
//  DegreeUnit.swift
//  Weather
//
//  Created by Khoa Le on 05/04/2022.
//

import Foundation

enum DegreeUnit: String, CustomStringConvertible {
    case `default`
    case metric
    case imperial

    var description: String {
        switch self {
        case .default:
            return "K"
        case .metric:
            return "°C"
        case .imperial:
            return "°F"
        }
    }
}
