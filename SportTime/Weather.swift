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
            self.cachedData.copyFirstDay()
            
            for i in 0...30 {
                
                print("time: \(self.cachedData.time[i]), temp: \(self.cachedData.temperature[i]) , wind: \(self.cachedData.windSpeed[i]),rain: \(self.cachedData.rainChanse[i]) %, hum: \(self.cachedData.humidity[i]) %, sky: \(self.cachedData.sky[i]) % ")
                
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

    private func getDataFrom(json: JSON) -> WeatherData  {
        
        var data = WeatherData()
        
        data.windSpeed = getWindSpeedFrom(json)
        data.time = getTimeFrom(json)
        data.temperature = getTemperatureFrom(json)
        data.rainChanse = getRainChanseFrom(json)
        data.humidity = getHumidityFrom(json)
        data.sky = getSkyFrom(json)
        
        return data
        
    }
    
    private func getSkyFrom(json: JSON) -> [Int] {
        
        var result = [Int]()
        
        for i in 0..<48 {
            
            let temp = json["hourly_forecast"][i]["sky"].intValue
            
            result.append(temp)
            
        }
        
        return result
    }

    
    private func getHumidityFrom(json: JSON) -> [Int] {
        
        var result = [Int]()
        
        for i in 0..<48 {
            
            let temp = json["hourly_forecast"][i]["humidity"].intValue
            
            result.append(temp)
            
        }
        
        return result
    }
    
    private func getRainChanseFrom(json: JSON) -> [Int] {
        
        var result = [Int]()
        
        for i in 0..<48 {
            
            let temp = json["hourly_forecast"][i]["pop"].intValue
            
            result.append(temp)
            
        }
        
        return result

        
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
        var rainChanse: [Int]
        var humidity: [Int]
        var sky: [Int]
        
        init() {
            
            time = [Int]()
            temperature = [Int]()
            windSpeed = [Int]()
            rainChanse = [Int]()
            humidity = [Int]()
            sky = [Int]()
            
        }
        
        mutating func copyFirstDay() {
            
            var temp = time[0] - 1
            if temp < 0 {
                temp += 24
            }
            self.time.insert(temp , atIndex: 0)
            self.temperature.insert(temperature[0], atIndex: 0)
            self.windSpeed.insert(windSpeed[0], atIndex: 0)
            self.rainChanse.insert(rainChanse[0], atIndex: 0)
            self.humidity.insert(humidity[0], atIndex: 0)
            self.sky.insert(sky[0], atIndex: 0)
            
        }

    }
    
    
}