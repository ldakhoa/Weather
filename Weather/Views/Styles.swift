//
//  Styles.swift
//  Weather
//
//  Created by Khoa Le on 05/04/2022.
//

import UIKit

enum Styles {
    enum Colors {
        static let white = UIColor.white
        static let background = "DEDEDE".color
        static let black = "0A0A0A".color
    }

    enum Text {
        static let body = UIFont.preferredFont(forTextStyle: .body)
        static let headline = UIFont.preferredFont(forTextStyle: .headline)
        static let h1 = UIFont.preferredFont(forTextStyle: .title1)
    }
}

extension String {
    public var color: UIColor {
        UIColor.fromHex(self)
    }
}
