//
//  SpyWeatherListViewable.swift
//  WeatherTests
//
//  Created by Khoa Le on 09/04/2022.
//

@testable import Weather

final class SpyWeatherListViewable: WeatherListViewable {
    var invokedToggleLoading = false
    var invokedToggleLoadingCount = 0
    var invokedToggleLoadingParameters: (isEnabled: Bool, Void)?
    var invokedToggleLoadingParametersList = [(isEnabled: Bool, Void)]()

    func toggleLoading(_ isEnabled: Bool) {
        invokedToggleLoading = true
        invokedToggleLoadingCount += 1
        invokedToggleLoadingParameters = (isEnabled, ())
        invokedToggleLoadingParametersList.append((isEnabled, ()))
    }
    
    var invokedReloadData = false
    var invokedReloadDataCount = 0

    func reloadData() {
        invokedReloadData = true
        invokedReloadDataCount += 1
    }

    var invokedShowAlert = false
    var invokedShowAlertCount = 0
    var invokedShowAlertParameters: (title: String, Void)?
    var invokedShowAlertParametersList = [(title: String, Void)]()

    func showAlert(withTitle title: String) {
        invokedShowAlert = true
        invokedShowAlertCount += 1
        invokedShowAlertParameters = (title, ())
        invokedShowAlertParametersList.append((title, ()))
    }
   
    var invokedToggleStatefulView = false
    var invokedToggleStatefulViewCount = 0
    var invokedToggleStatefulViewParameters: (state: StatefulState, Void)?
    var invokedToggleStatefulViewParametersList = [(state: StatefulState, Void)]()
    
    func toggleStatefulView(withState state: StatefulState) {
        invokedToggleStatefulView = true
        invokedToggleStatefulViewCount += 1
        invokedToggleStatefulViewParameters = (state, ())
        invokedToggleStatefulViewParametersList.append((state, ()))
    }
}
