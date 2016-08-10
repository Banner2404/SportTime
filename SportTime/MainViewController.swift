//
//  MainViewController.swift
//  SportTime
//
//  Created by Соболь Евгений on 05.08.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, WeatherDelegate, SettingsUpdateDelegate {

    @IBOutlet weak var dynamicClockView: DynamicClockView!
    @IBOutlet weak var weatherIcon: UIImageView!

    @IBOutlet var weatherLabels: [UILabel]!
    let weather = Weather.sharedWeather
    let settings = Settings.sharedSettings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weather.delegate = self
        settings.updateDelegate = self

        weather.refresh()
        settings.update()
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
        navigationController?.navigationBar.tintColor = UIColor.orangeColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: WeatherDelegate
    
    func didUpdateWeatherInfo(info: Weather.WeatherData) {
        
        for i in 0..<weatherLabels.count {
            
            let label = weatherLabels[i]
            var state = ClockData.ParamState.Bad
            switch i {
            case 0:
                label.text = String(info.temperature) + " °C"
                state = settings.getStateForKey(Settings.tempID, andValue: info.temperature)
            case 1:
                label.text = String(info.windSpeed) + " км/ч"
                state = settings.getStateForKey(Settings.windID, andValue: info.windSpeed)
            case 2:
                label.text = String(info.rainChanse) + " %"
                state = settings.getStateForKey(Settings.rainID, andValue: info.rainChanse)
            case 3:
                label.text = String(info.humidity) + " %"
                state = settings.getStateForKey(Settings.humidityID, andValue: info.humidity)
            case 4:
                label.text = String(info.sky) + " %"
                state = settings.getStateForKey(Settings.skyID, andValue: info.sky)
            default:
                break
            }
            
            switch state {
            case .Bad:
                label.textColor = UIColor.redColor()
            case .Good:
                label.textColor = UIColor.greenColor()

            }
            
            
        }
        
    }
    
    func didUpdateWeatherImage(image: UIImage) {
        
        self.weatherIcon.image = image
    }
    
    func didUpdateWeather() {
        
        let clockData = ClockData(weather: weather.cachedData)
        
        self.dynamicClockView.clockData = clockData.conditions
        
        self.dynamicClockView.setNeedsDisplay()
        
        print("Screen update")
        //TODO: dynamic time
        weather.getWeatherInfoFor(20)
        
    }
    
    //MARK: SettingsUpdateDelegate
    
    func didUpdateSettings() {
        
        let clockData = ClockData(weather: weather.cachedData)
        
        self.dynamicClockView.clockData = clockData.conditions
        
        self.dynamicClockView.setNeedsDisplay()
        
        print("Screen update")
        
        weather.getWeatherInfoFor(20)

        
    }

    
}

extension NSDate {
    
    class func getTime() -> (h: Int, m: Int) {
        
        let date = NSDate.init(timeIntervalSinceNow: 0)
        let calendar = NSCalendar.currentCalendar()
        let unit: NSCalendarUnit = [.Hour, .Minute]
        let comp = calendar.components(unit, fromDate: date)
        
        
        
        return (comp.hour, comp.minute)
    }
    
}
