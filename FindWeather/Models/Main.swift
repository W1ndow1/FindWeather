//
//  Main.swift
//  FindWeather
//
//  Created by window1 on 2023/02/08.
//

import Foundation

struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int
    let tempKf: Double
     
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel
        case grndLevel
        case humidity
        case tempKf = "temp_Kf"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temp = (try? container.decode(Double.self, forKey: .temp)) ?? 0.0
        self.feelsLike = (try? container.decode(Double.self, forKey: .feelsLike)) ?? 0.0
        self.tempMin = (try? container.decode(Double.self, forKey: .tempMin)) ?? 0.0
        self.tempMax = (try? container.decode(Double.self, forKey: .tempMax)) ?? 0.0
        self.pressure = (try? container.decode(Int.self, forKey: .pressure)) ?? 0
        self.humidity = (try? container.decode(Int.self, forKey: .humidity)) ?? 0
        self.seaLevel = (try? container.decode(Int.self, forKey: .seaLevel)) ?? 0
        self.grndLevel = (try? container.decode(Int.self, forKey: .grndLevel)) ?? 0
        self.tempKf = (try? container.decode(Double.self, forKey: .tempKf)) ?? 0.0
    }
}


