//
//  Weather.swift
//  Weather_AntonSamonin
//
//  Created by Anton Samonin on 11/23/18.
//  Copyright © 2018 AntCo. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift


class Weather: Object {
   @objc dynamic var date = 0
   @objc dynamic var tempreture: Float = 0.0
   @objc dynamic var pressure = 0.0
   @objc dynamic var wind = 0.0
   @objc dynamic var humidity = 0
    
   
   @objc dynamic var weatherName = ""
   @objc dynamic var weatherIcon = ""
   @objc dynamic var dayOfTheWeek = ""
    
    convenience init(json: JSON) {
        self.init()
        self.date = json["dt"].intValue
        self.tempreture = json["main"]["temp"].floatValue
        self.pressure = json["main"]["pressure"].doubleValue
        self.weatherName = json["weather"][0]["main"].stringValue
        self.weatherIcon = json["weather"][0]["icon"].stringValue
        self.wind = json["wind"]["speed"].doubleValue
        self.humidity = json["main"]["humidity"].intValue
        self.dayOfTheWeek = dateFormatter(format: "EEEE dd MMMM")
        
    }
    override static func primaryKey() -> String? {
        return "date"
    }
    override static func  indexedProperties() -> [String] {
        return ["dayOfTheWeek"]
    }
}

extension Weather {
    func dateFormatter(format: String) -> String {
        var dateFormatter: DateFormatter {
            let dt = DateFormatter()
            dt.dateFormat = format
            dt.timeZone = TimeZone.current
            dt.locale = Locale(identifier: "ru_RU")
            return dt
        }
        let dayOfTheWeek = Date(timeIntervalSince1970: Double(date))
        let dayOfTheWeekStr = dateFormatter.string(from: dayOfTheWeek)
        return dayOfTheWeekStr
    }
}



