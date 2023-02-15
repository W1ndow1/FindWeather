//
//  Converter.swift
//  FindWeather
//
//  Created by window1 on 2023/02/09.
//

import Foundation

class DateConverter {
   static func convertingUTCTime(_ dt: String) -> Date {
        let timeInterval = TimeInterval(dt)!
        let utcTime = Date(timeIntervalSince1970: timeInterval)
        return utcTime
    }
}
