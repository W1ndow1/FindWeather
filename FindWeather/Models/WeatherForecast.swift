//
//  WeatherForecast.swift
//  FindWeather
//
//  Created by ChangwonKim on 2023/02/22.
//

import Foundation

struct WeatherForecast: Codable {
    let cod: String
    let message, cnt: Int
    let list: [ForecastList]
    let city: City
}

struct City: Codable{
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}
