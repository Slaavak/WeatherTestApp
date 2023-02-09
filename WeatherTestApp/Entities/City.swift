//
//  City.swift
//  WeatherTestApp
//
//  Created by Slava Korolevich on 9.02.23.
//

import Foundation

struct City: Codable {
    var sunrise: Int?
    var sunset: Int?
    var id: Int?
    var country: String?
    var population: Int?
    var timezone: Int?
    var coord: Coord?
    var name: String?
}
