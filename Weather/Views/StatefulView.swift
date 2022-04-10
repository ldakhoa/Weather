//
//  StatefulView.swift
//  Weather
//
//  Created by Khoa Le on 05/04/2022.
//

import UIKit

enum StatefulState: CustomStringConvertible {
    case findCity
    case onHide
    case tryAgain

    var description: String {
        switch self {
        case .findCity:
            return "Find your city"
        case .onHide:
            return ""
        case .tryAgain:
            return "Please enter another keyword"
        }
    }
}

/// A view displays a dedicated state, it usually cover other view's content.
final class StatefulView: UIView {
    /// A label display description of stateful view.
    private(set) lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.text = "There's no city found"
        view.font = .preferredFont(forTextStyle: .headline)
        view.textAlignment = .center
        view.isAccessibilityElement = true
        view.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

    // MARK: - Side Effects

    func updateTitle(_ state: StatefulState) {
        descriptionLabel.text = state.description
    }

    private func setupLayout() {
        addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
}

