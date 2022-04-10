//
//  City.swift
//  Weather
//
//  Created by Khoa Le on 05/04/2022.
//

import Foundation

public struct City: Decodable {
    let id: Int
    let name: String
    let country: String
    let timezone: Int
    let population: Int
}
