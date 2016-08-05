//
//  ClockData.swift
//  SportTime
//
//  Created by Соболь Евгений on 05.08.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

import UIKit

class ClockData: NSObject {

    var conditions = [HourlyState]()
    let settings = Settings.sharedSettings
    
    init(weather: Weather.WeatherData) {
        super.init()
        
//        for i in 0..<weather.time.count {
//            
//            var score = 0
//            
//            for parameter in settings.active {
//                
//                let mul = Settings.paramsCount - parameter.order
//                
//                var state: HourlyState
//                }
//                
//            }
//            
//        }
        
    }
    
    enum HourlyState {
        case Good(inTime: Bool)
        case Medium(inTime: Bool)
        case Bad(inTime: Bool)
    }
    
    enum ParamState: Int {
        case Bad = 1
        case Good = 2
    }

}
