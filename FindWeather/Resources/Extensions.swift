//
//  Extensions.swift
//  FindWeather
//
//  Created by window1 on 2023/02/05.
//

import Foundation
import UIKit

extension String {
    func codeToCityName(id: Int) -> String{
        let data: [Int : String] = [
                1842616 : "공주",
                1841811 : "광주",
                1842225 : "구미",
                1842025 : "군산",
                1835327 : "대구",
                1835224 : "대전",
                1841066 : "목포",
                1838524 : "부산",
                1835895 : "서산",
                1835848 : "서울",
                1836553 : "속초",
                1835553 : "수원",
                1835648 : "순천",
                1833747 : "울산",
                1843491 : "익산",
                1845457 : "전주",
                1846265 : "제주",
                1845759 : "천안",
                1845033 : "청주",
                1845136 : "춘천"
                ]
        return data[id] ?? ""
    }
}

extension Date {
    func toString( dataFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    func toStringKST( dataFormat format: String) -> String {
        return self.toString(dataFormat: format)
    }
    
    func toStringUTC( _ timezone: Int) -> String {
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "a h:m"
        dateFomatter.timeZone = TimeZone(secondsFromGMT: timezone)
        return dateFomatter.string(from: self)
    }
}
