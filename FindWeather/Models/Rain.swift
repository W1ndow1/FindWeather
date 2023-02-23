//
//  Rain.swift
//  FindWeather
//
//  Created by ChangwonKim on 2023/02/22.
//

import Foundation

struct Rain: Codable {
    let the3H: Double

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.the3H = try container.decode(Double.self, forKey: .the3H)
    }
}
