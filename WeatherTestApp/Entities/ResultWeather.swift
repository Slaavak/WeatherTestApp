//
//  ResultWeather.swift
//  WeatherTestApp
//
//  Created by Slava Korolevich on 9.02.23.
//

import Foundation

struct ResultWeather: Codable {
    var message: Int?
    var cnt: Int?
    var cod: String?
    var list: [List]?
    var city: City?
}
