//
//  WeatherListBuilder.swift
//  Weather
//
//  Created by Khoa Le on 04/04/2022.
//

import UIKit

/// An object helps to build a scene that displays the weather lists.
struct WeatherListingBuilder {
    /// Build a scene that displays the details of weather listing.
    /// - Returns: A view controller displays the details of weather listing.
    func build() -> UIViewController {
        let presenter = WeatherListPresenter()
        let viewController = WeatherListViewController(presenter: presenter)

        // Connect the view controller to the presenter.
        presenter.view = viewController

        // Return the result
        return viewController
    }
}
