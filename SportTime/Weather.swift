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
    
    var data =  WeatherData()
    var cachedData = WeatherData()
    
    static let sharedWeather = Weather()
    
    func refresh() {
        
        self.getHourlyWeather { [unowned self] json in
            
            
            self.cachedData = self.getDataFrom(json) //TODO: make caching
            
            for i in 0...30 {
                
                print("time: \(self.cachedData.time[i]), temp: \(self.cachedData.temperature[i]) , wind: \(self.cachedData.windSpeed[i]) ")
                
            }
            
            //TODO: update clock
            
            
        }

        
    }
    
    //MARK: - Getting data from server
    
//    private func getCurrentWeather(onSuccess onSuccess: (JSON) -> ()) {
//        
//        let urlString = "http://api.wunderground.com/api/892b2fb5ca02a3b4/conditions/lang:RU/q/52.7,25.3.json"
//        
//        Alamofire.request(.GET, urlString).responseJSON { response in
//
//            if let json = response.result.value {
//                
//                let weatherJSON = JSON(json)
//                
//                onSuccess(weatherJSON)
//                
//            } else if let error = response.result.error {
//                
//                print(error.localizedDescription)
//                
//            }
//            
//        }
//    }
    
    private func getHourlyWeather(onSuccess onSuccess: (JSON) -> ()) {
        
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
    
//    private func getCurrentDataFrom(json: JSON) -> WeatherData {
//        
//        var data = WeatherData()
//        
//        var time = json["current_observation"]["local_time_rfc822"].stringValue
//
//        time = time.componentsSeparatedByString(":")[0]
//        time = time.componentsSeparatedByString(" ").last!
//
//        data.time.append(Int(time)!)
//        
//        data.temperature.append(json["current_observation"]["temp_c"].int!)
//        data.windSpeed.append(json["current_observation"]["wind_kph"].int!)
//        
//        return data
//        
//    }
    
    private func getDataFrom(json: JSON) -> WeatherData  {
        
        var data = WeatherData()
        
        data.windSpeed = getWindSpeedFrom(json)
        data.time = getTimeFrom(json)
        data.temperature = getTemperatureFrom(json)
        
        return data
        
    }
    
    private func getWindSpeedFrom(json: JSON) -> [Int] {
        
        var result = [Int]()
        
        for i in 0..<48 {
            
            let temp = json["hourly_forecast"][i]["wspd"]["metric"].intValue
            
            result.append(temp)
            
        }
        
        return result
    }

    
    private func getTimeFrom(json: JSON) -> [Int] {
        
        var result = [Int]()
        
        for i in 0..<48 {
            
            let temp = json["hourly_forecast"][i]["FCTTIME"]["hour"].intValue
            
            
            result.append(temp)
            
            
        }
        
        return result
    }
    
    private func getTemperatureFrom(json: JSON) -> [Int] {
        
        var result = [Int]()
        
        for i in 0..<48 {
            
            let temp = json["hourly_forecast"][i]["temp"]["metric"].intValue
            
            
            result.append(temp)
            
            
        }
        
        return result
    }
    
}

extension Weather {
    
    struct WeatherData {
        var time: [Int]
        var temperature: [Int]
        var windSpeed: [Int]
        
        init() {
            
            time = [Int]()
            temperature = [Int]()
            windSpeed = [Int]()
            
        }

    }
    
    
}

func + (a: Weather.WeatherData, b: Weather.WeatherData) -> Weather.WeatherData {
    
    var c = Weather.WeatherData()
    
    c.time = a.time + b.time
    c.temperature = a.temperature + b.temperature
    c.windSpeed = a.windSpeed + b.windSpeed
    
    return c
}

func += (inout a: Weather.WeatherData, b: Weather.WeatherData) {
    
    a = a + b
    
}


