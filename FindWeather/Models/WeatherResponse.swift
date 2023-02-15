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
    let sys: SysByName
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

struct SysByName: Codable {
    let sunrise, sunset, id, type: Int
    let country: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.country = (try? container.decode(String.self, forKey: .country)) ?? ""
        self.sunrise = (try? container.decode(Int.self, forKey: .sunrise)) ?? 0
        self.sunset = (try? container.decode(Int.self, forKey: .sunset)) ?? 0
        self.id = (try? container.decode(Int.self, forKey: .id)) ?? 0
        self.type = (try? container.decode(Int.self, forKey: .type)) ?? 0
    }
}


