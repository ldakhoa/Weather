//
//  Weather.swift
//  Weather
//
//  Created by Khoa Le on 05/04/2022.
//

import Foundation

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
