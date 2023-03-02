//
//  ForecastList.swift
//  FindWeather
//
//  Created by window1 on 2023/02/22.
//

import Foundation

struct ForecastList: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let rain: Rain?
    let sys: SysByName
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, sys
        case dtTxt = "dt_txt"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dt = try container.decode(Int.self, forKey: .dt)
        self.main = try container.decode(Main.self, forKey: .main)
        self.weather = try container.decode([Weather].self, forKey: .weather)
        self.clouds = try container.decode(Clouds.self, forKey: .clouds)
        self.wind = try container.decode(Wind.self, forKey: .wind)
        self.visibility = try container.decode(Int.self, forKey: .visibility)
        self.pop = try container.decode(Double.self, forKey: .pop)
        self.rain = try container.decodeIfPresent(Rain.self, forKey: .rain)
        self.sys = try container.decode(SysByName.self, forKey: .sys)
        self.dtTxt = try container.decode(String.self, forKey: .dtTxt)
    }
}
