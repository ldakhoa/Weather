//
//  UserDefaultManagement.swift
//  Weather
//
//  Created by Khoa Le on 05/04/2022.
//

import Foundation

private struct UserDefaultKeys {
    static let lastKeyword = "last_keyword"
}

final class UserDefaultManagement {
    private static var shared: UserDefaults? = UserDefaults(suiteName: "com.ldakhoa.weather.user.defaults")
    private typealias Keys = UserDefaultKeys

    static var lastKeyword: String {
        get {
            if let result = shared?.object(forKey: Keys.lastKeyword) as? String {
                return result
            }
            return ""
        }
        set {
            shared?.set(newValue, forKey: Keys.lastKeyword)
        }
    }
}
