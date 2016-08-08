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
    
    func didUpdateWeather() {
        
        let clockData = ClockData(weather: weather.cachedData)
        
        self.dynamicClockView.clockData = clockData.conditions
        
        self.dynamicClockView.setNeedsDisplay()
        
        print("Screen update")
        
    }
    
    //MARK: SettingsUpdateDelegate
    
    func didUpdateSettings() {
        
        let clockData = ClockData(weather: weather.cachedData)
        
        self.dynamicClockView.clockData = clockData.conditions
        
        self.dynamicClockView.setNeedsDisplay()
        
        print("Screen update")
        
    }

    
}
