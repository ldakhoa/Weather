//
//  WeatherListCache.swift
//  Weather
//
//  Created by Khoa Le on 09/04/2022.
//

import Foundation

/// A cache layer that use to cache forecasts data to reduce API requests.
final class WeatherListCache {
    /// The expired time.
    private let expiredTime: TimeInterval
    
    /// The dictionary use to cache data.
    private var dict = [String: [Forecast]]()
    
    /// A timer that fires after a certain time interval has elapsed, sending a specified message to a target object.
    private var timer: Timer?

    // MARK: - Init
    
    init(expiredTime: TimeInterval = 10 * 60) {
        self.expiredTime = expiredTime
        updateCacheTimer()
    }
    
    // MARK: - Side Effects - Public
    
    func add(_ item: [Forecast], for city: String) {
        guard dict[city] == nil else {
            return
        }
        print("Append \(item) to cache")
        dict[city] = item
    }
    
    func forecasts(fromCity city: String) -> [Forecast]? {
        dict[city]
    }
    
    func clear() {
        print("Cache is cleared")
        dict.removeAll()
        dict = [:]
    }
    
    // MARK: - Side Effects - Private
    
    private func updateCacheTimer() {
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(
            timeInterval: expiredTime,
            target: self,
            selector: #selector(onTimer),
            userInfo: nil,
            repeats: true)
    }

    @objc private func onTimer() {
        clear()
    }

}
