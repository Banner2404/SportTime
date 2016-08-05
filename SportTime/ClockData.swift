//
//  ClockData.swift
//  SportTime
//
//  Created by Соболь Евгений on 05.08.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

import UIKit

class ClockData: NSObject {

    var conditions = [HourlyInfo]()
    let settings = Settings.sharedSettings
    
    init(weather: [Weather.WeatherData]) {
        super.init()
        
        for hour in weather {
            
            var score = 0
            var maxScore = 0
            
            for params in settings.active {
                
                let mul = settings.paramsCount - params.order
                
                var points: ParamState
                
                switch params.identifier {
                case Settings.tempID where (hour.temperature >= params.min) && (hour.temperature <= params.max):
                    points = .Good
                case Settings.tempID:
                    points = .Bad
                case Settings.windID where (hour.windSpeed >= params.min) && (hour.windSpeed <= params.max):
                    points = .Good
                case Settings.windID:
                    points = .Bad
                case Settings.rainID where (hour.rainChanse >= params.min) && (hour.rainChanse <= params.max):
                    points = .Good
                case Settings.rainID:
                    points = .Bad
                case Settings.humidityID where (hour.humidity >= params.min) && (hour.humidity <= params.max):
                    points = .Good
                case Settings.humidityID:
                    points = .Bad
                case Settings.skyID where (hour.sky >= params.min) && (hour.sky <= params.max):
                    points = .Good
                case Settings.skyID:
                    points = .Bad
                default:
                    points = .Good
                }
                
                score += mul * points.rawValue
                maxScore += mul * ParamState.Good.rawValue
                
            }
            
            let rel = Double(score) / Double(maxScore)
            let time = hour.time >= settings.time.min && hour.time < settings.time.max ? true : false
            var info = HourlyInfo()
            info.time = hour.time
            
            switch rel {
            case 0.66...1:
                info.state = .Good(inTime: time)
            case 0.33..<0.66:
                info.state = .Medium(inTime: time)
            default:
                info.state = .Bad(inTime: time)
            }
            
            print("time: \(hour.time), temp: \(hour.temperature), wind: \(hour.windSpeed), cond: \(info.state), pts: \(score), max: \(maxScore)")
            conditions.append(info)
            
        }
        
    }
    
    struct HourlyInfo {
        var time = 0
        var state = HourlyState.Good(inTime: true)
    }
    
    enum HourlyState {
        case Good(inTime: Bool)
        case Medium(inTime: Bool)
        case Bad(inTime: Bool)
    }
    
    enum ParamState: Int {
        case Bad = 0
        case Good = 1
    }

}
