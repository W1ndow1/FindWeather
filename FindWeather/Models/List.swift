//
//  List.swift
//  FindWeather
//
//  Created by window1 on 2023/02/08.
//

import Foundation

struct List: Codable{
    let coord: Coord
    let sys: Sys
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt, id: Int?
    let name: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.coord = try container.decode(Coord.self, forKey: .coord)
        self.sys = try container.decode(Sys.self, forKey: .sys)
        self.weather = try container.decode([Weather].self, forKey: .weather)
        self.main = try container.decode(Main.self, forKey: .main)
        self.visibility = try container.decode(Int.self, forKey: .visibility)
        self.wind = try container.decode(Wind.self, forKey: .wind)
        self.clouds = try container.decode(Clouds.self, forKey: .clouds)
        self.dt = try container.decodeIfPresent(Int.self, forKey: .dt)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
    }
}



