//
//  Weather.swift
//  WeatherTestApp
//
//  Created by Slava Korolevich on 9.02.23.
//

import Foundation

struct Weather: Codable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}
