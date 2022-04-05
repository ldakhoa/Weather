//
//  WeatherListPresenter.swift
//  Weather
//
//  Created by Khoa Le on 04/04/2022.
//

import Foundation
import UIKit

/// A passive object that displays the details of a weather.
protocol WeatherListViewable: AnyObject {
    /// Show or hide the loading view.
    /// - Parameter isEnabled: A boolean indicating whether the loading view is showed or hidden.
    func toggleLoading(_ isEnabled: Bool)

    /// Reload all of the data.
    func reloadData()

    /// Show alert with title.
    /// - Parameter title: A title to show.
    func showAlert(withTitle title: String)

    /// Show or hide the stateful view.
    /// - Parameter state: A state of the stateful view.
    func toggleStatefulView(withState state: StatefulState)
}

/// An object acts upon weather data and the associated view to display weather info.
final class WeatherListPresenter: WeatherListPresentable {

    // MARK: - Dependencies

    /// A passive object that displays the details of a weather.
    weak var view: WeatherListViewable?

    /// An object provides methods for interacting with the user data in the remote database.
    let weatherListUseCase: WeatherListUseCase

    /// The temperature unit.
    let degreeUnit: DegreeUnit

    // MARK: - Misc

    /// A list of forecasts.
    private(set) var forecasts = [Forecast]()

    /// A view displays a dedicated state, it usually cover other view's content.
    private(set) var statefulState: StatefulState = .findCity

    // MARK: - Init

    /// Initiates a presenter acts upon the list data and the associated view to display weather list.
    /// - Parameters:
    ///   - weatherListUseCase: An object provides methods for interacting with the user data in the remote database.
    ///   - degreeUnit: The temperature unit.
    init(
        weatherListUseCase: WeatherListUseCase = DefaultWeatherListUseCase(),
        degreeUnit: DegreeUnit = .metric
    ) {
        self.weatherListUseCase = weatherListUseCase
        self.degreeUnit = degreeUnit
    }

    // MARK: - Side Effects

    /// Reload all data of the WeatherList's services.
    func reloadData(city: String = "", shouldShowLoading: Bool) {
        if shouldShowLoading { view?.toggleLoading(true) }
        weatherListUseCase.weather(
            byKeyword: city,
            numberOfDays: 7,
            degreeUnit: degreeUnit
        ) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view?.toggleLoading(false)
                switch result {
                case let .success(forecasts):
                    UserDefaultManagement.lastKeyword = city
                    self.statefulState = .onHide
                    self.forecasts = forecasts
                case let .failure(error):
                    self.view?.showAlert(withTitle: error.description)
                    self.statefulState = .tryAgain
                    self.forecasts.removeAll()
                }
                self.view?.reloadData()
            }
        }
    }

    // MARK: - WeatherListsPresentable

    func viewWillAppear() {
        let lastKeyword = UserDefaultManagement.lastKeyword
        if !lastKeyword.isEmpty {
            reloadData(city: lastKeyword, shouldShowLoading: true)
        }
    }

    func numberOfSections() -> Int {
        1
    }

    func numberOfRows(in section: Int) -> Int {
        view?.toggleStatefulView(withState: statefulState)
        return forecasts.count
    }

    func forecasts(at indexPath: IndexPath) -> Forecast {
        forecasts[indexPath.row]
    }

    func didChangeValueRefreshControl() {
        reloadData(city: UserDefaultManagement.lastKeyword, shouldShowLoading: false)
    }

    func searchForecast(byCity city: String) {
        reloadData(city: city, shouldShowLoading: true)
    }

    func cleanup() {
        statefulState = .findCity
        forecasts.removeAll()
        view?.reloadData()
    }
}
