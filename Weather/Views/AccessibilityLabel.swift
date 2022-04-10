//
//  AccessibilityLabel.swift
//  Weather
//
//  Created by Khoa Le on 05/04/2022.
//

import UIKit

class AccessibilityLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }

    // MARK: - Side Effects

    private func setupLabel() {
        font = Styles.Text.body
        adjustsFontForContentSizeCategory = true
        numberOfLines = 0
        textColor = Styles.Colors.black
        textAlignment = .left
        isAccessibilityElement = true
    }
}
