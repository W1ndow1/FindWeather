//
//  Wind.swift
//  FindWeather
//
//  Created by window1 on 2023/02/07.
//

import Foundation

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

extension Wind {
    func degToString(position: Int) -> String {
        switch deg {
        case 11...34:
            return "북북동"
        case 35...56:
            return "북동"
        case 57...78:
            return "동북동"
        case 79...101:
            return "동"
        case 102...123:
            return "동남동"
        case 124...146:
            return "남동"
        case 147...168:
            return "남남동"
        case 169...191:
            return "남"
        case 192...213:
            return "남남서"
        case 214...236:
            return "남서"
        case 237...258:
            return "서남서"
        case 259...281:
            return "서"
        case 282...303:
            return "서북서"
        case 304...326:
            return "북서"
        case 327...348:
            return "북북서"
        default:
            return "북"
        }
    }
}
