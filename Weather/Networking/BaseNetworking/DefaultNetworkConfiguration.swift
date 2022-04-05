//
//  DefaultNetworkConfiguration.swift
//  Weather
//
//  Created by Khoa Le on 05/04/2022.
//

import Foundation

/// Default network configuration.
public struct DefaultNetworkConfiguration {
    static var appID: String {
        "60c6fbeb4b93ac653c492ba806fc346d"
    }
    
    static func makeBaseURL() -> String {
        return "https://api.openweathermap.org/"
    }
}
