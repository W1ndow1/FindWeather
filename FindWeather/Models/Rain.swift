//
//  Rain.swift
//  FindWeather
//
//  Created by window1 on 2023/02/22.
//

import Foundation

struct Rain: Codable {
    let the3H: Double

    
    enum CodingKeys: String, CodingKey {
            case the3H = "3h"
        }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.the3H = (try? container.decode(Double.self, forKey: .the3H)) ?? 0.0
    }
}
