//
//  Double+Date.swift
//  Weather
//
//  Created by Khoa Le on 05/04/2022.
//

import Foundation

extension Double {
    func toString() -> String {
        let date = Date(timeIntervalSince1970: self)
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.calendar = .current
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "EE, dd MMMM yyyy"
        return formatter.string(from: date)
    }
}
