//
//  List.swift
//  WeatherTestApp
//
//  Created by Slava Korolevich on 9.02.23.
//

import Foundation

struct List: Codable {
    var dt: Int?
    var main: Main?
    var weather: [Weather]?
    var clouds: Clouds?
    var wind: Wind?
    var visibility: Int
    var pop: Double?
    var sys: Sys?
    var dt_txt: String?
}
