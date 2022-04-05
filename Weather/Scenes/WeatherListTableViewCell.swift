//
//  WeatherListTableViewCell.swift
//  Weather
//
//  Created by Khoa Le on 04/04/2022.
//

import UIKit

/// The visual representation of a weather data in a table view.
final class WeatherListTableViewCell: UITableViewCell {
    /// The reuse identifier to use when registering and later dequeuing a reusable cell
    static var reuseIdentifier: String {
        String(describing: self)
    }

    // MARK: - UIs

    private lazy var dateLabel: AccessibilityLabel = {
        let view = AccessibilityLabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var averageTemperatureLabel: AccessibilityLabel = {
        let view = AccessibilityLabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var pressureLabel: AccessibilityLabel = {
        let view = AccessibilityLabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var humidityLabel: AccessibilityLabel = {
        let view = AccessibilityLabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var descriptionLabel: AccessibilityLabel = {
        let view = AccessibilityLabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            dateLabel,
            averageTemperatureLabel,
            pressureLabel,
            humidityLabel,
            descriptionLabel
        ])
        view.axis = .vertical
        view.spacing = 12
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

    // MARK: - Side Effects

    func update(withForecast forecast: Forecast, unit: DegreeUnit) {
        dateLabel.text = "Date: \(forecast.dateTime.toString())"
        let avgTemperature = Int(forecast.temperature.min + forecast.temperature.max) /  2
        averageTemperatureLabel.text = "Average Temperature: \(avgTemperature)\(unit)"
        pressureLabel.text = "Pressure: \(forecast.pressure)"
        humidityLabel.text = "Humidity: \(forecast.humidity)%"
        if let description = forecast.weather.first?.description {
            descriptionLabel.text = "Description: \(description)"
        } else {
            descriptionLabel.text = "Description: updating..."
        }
    }

    private func setupLayout() {
        contentView.backgroundColor = Styles.Colors.background
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
