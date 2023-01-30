//
//  WeatherResponse.swift
//  FindWeather
//
//  Created by window1 on 2023/02/01.
//

import Foundation

struct WeatherResponseCode: Codable {
    let cnt: Int
    let list: [List]
}
struct WeatherResponseName: Codable{
    let main: Main
    let wind: Wind
    let name: String?
    let weather: [Weather]
    let dt: Int
    let id: Int
}

struct Clouds: Codable {
    let all: Int
}

struct Coord: Codable {
    let lon, lat: Double
}

struct Sys: Codable {
    let country: String
    let timezone, sunrise, sunset: Int
}
