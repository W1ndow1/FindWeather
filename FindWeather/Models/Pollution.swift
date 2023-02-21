//
//  Pollution.swift
//  FindWeather
//
//  Created by window1 on 2023/02/20.
//

import Foundation

struct Pollution {
    let coord: [Int]
    let list: [PollutionList]
}

struct PollutionList {
    let dt: Int
    let main: PollutionMain
    let components: [String: Double]
}

struct PollutionMain{
    let api: Int
}
