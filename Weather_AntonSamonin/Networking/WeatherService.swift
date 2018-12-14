//
//  WeatherService.swift
//  Weather_AntonSamonin
//
//  Created by Anton Samonin on 11/23/18.
//  Copyright © 2018 AntCo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherService {
    private let apiKey = "9f66525ebe97cc41cbf93d6045ada3b8"
    let baseUrl = "https://api.openweathermap.org"
    let path = "/data/2.5/forecast"
    
    func loadWeatherForecast(cityName: String, completion: (([Weather]?, Error?) -> Void)? = nil) {
        
        
        let params: Parameters = [
            "appid": apiKey,
            "q": cityName,
            "units": "metric"
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON { (response) in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                let weathers = json["list"].arrayValue.map{return Weather(json: $0)}
                completion?(weathers,nil)
           
            case .failure(let error):
                completion?(nil, error)
            }
        }
        
    }
    static func urlForWeatherIcon(_ icon: String) -> URL? {
        return URL(string: "https://openweathermap.org/img/w/\(icon).png")
    }
}
