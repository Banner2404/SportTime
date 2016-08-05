//
//  Weather.swift
//  SportTime
//
//  Created by Соболь Евгений on 03.08.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Weather: NSObject {
    
    var data =  [WeatherData]()
    var cachedData = [WeatherData]()
    
    static let sharedWeather = Weather()
    
    func refresh() {
        
        self.getHourlyWeather { [unowned self] json in
            
            
            self.cachedData = self.getDataFrom(json) //TODO: make caching
            
            for i in 0...30 {
                
                print("time = \(self.cachedData[i].time), " +
                    "temp = \(self.cachedData[i].temperature)," +
                    "wind = \(self.cachedData[i].windSpeed)," +
                    "rain = \(self.cachedData[i].rainChanse)," +
                    "hum = \(self.cachedData[i].humidity)," +
                    "sky = \(self.cachedData[i].sky),")
                
            }
            
            //TODO: update clock
            
            
        }

        
    }
    
    //MARK: - Getting data from server
    
    
    private func getHourlyWeather(onSuccess: (JSON) -> ()) {
        
        let urlString = "http://api.wunderground.com/api/892b2fb5ca02a3b4/hourly10day/lang:RU/q/52.7,25.3.json"
        
        Alamofire.request(.GET, urlString).responseJSON { response in
            
            if let json = response.result.value {
                
                let weatherJSON = JSON(json)
                
                onSuccess(weatherJSON)
                
            } else if let error = response.result.error {
                
                print(error.localizedDescription)
                
            }
            
        }
        
    }
    
    //MARK: - Parsing

    private func getDataFrom(json: JSON) -> [WeatherData]  {
        
        var data = [WeatherData]()

        for i in 0..<48 {
            
            let time = json["hourly_forecast"][i]["FCTTIME"]["hour"].intValue
            let temp = json["hourly_forecast"][i]["temp"]["metric"].intValue
            let wind = json["hourly_forecast"][i]["wspd"]["metric"].intValue
            let rain = json["hourly_forecast"][i]["pop"].intValue
            let humidity = json["hourly_forecast"][i]["humidity"].intValue
            let sky = json["hourly_forecast"][i]["sky"].intValue
            
            let weather = WeatherData(time: time, temperature: temp,
                                      windSpeed: wind, rainChanse: rain,
                                      humidity: humidity, sky: sky)
            
            data.append(weather)
            
        }
        
        data = copyFirst(data)

        return data
        
    }
    
    private func copyFirst(weather: [WeatherData]) -> [WeatherData] {
        
        var w = weather
        w.insert(weather[0], atIndex: 0)
        return w
    }
    
}

extension Weather {
    
    struct WeatherData {
        
        var time: Int
        var temperature: Int
        var windSpeed: Int
        var rainChanse: Int
        var humidity: Int
        var sky: Int
    }
    
    
}