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
}



