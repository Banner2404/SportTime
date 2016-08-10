//
//  MainViewController.swift
//  SportTime
//
//  Created by Соболь Евгений on 05.08.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, WeatherDelegate, SettingsUpdateDelegate, UIScrollViewDelegate {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var weatherLabels: [UILabel]!
    @IBOutlet weak var pageControl: UIPageControl!

    let weather = Weather.sharedWeather
    let settings = Settings.sharedSettings
    var dynamicClockView: DynamicClockView!
    var staticClockView1: StaticClockView!
    var staticClockView2: StaticClockView!
    var height: CGFloat = 0
    var width: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weather.delegate = self
        settings.updateDelegate = self
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
        navigationController?.navigationBar.tintColor = UIColor.orangeColor()
        height = scrollView.frame.height
        width = scrollView.frame.width
        
        dynamicClockView = DynamicClockView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        staticClockView1 = StaticClockView(frame: CGRect(x: width, y: 0, width: width, height: height))
        staticClockView2 = StaticClockView(frame: CGRect(x: width * 2, y: 0, width: width, height: height))
        
        staticClockView2.startingTime = 12
        
        scrollView.addSubview(dynamicClockView)
        scrollView.addSubview(staticClockView1)
        scrollView.addSubview(staticClockView2)
        
        scrollView.contentSize = CGSizeMake(width * 3, height)
        
        weather.refresh()
        settings.update()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateInfo() {
        
        let clockData = ClockData(weather: weather.cachedData)
        
        dynamicClockView.clockData = clockData.conditions
        staticClockView1.clockData = clockData.conditions
        staticClockView2.clockData = clockData.conditions

        self.dynamicClockView.setNeedsDisplay()
        self.staticClockView1.setNeedsDisplay()
        self.staticClockView2.setNeedsDisplay()
        
        print("Screen update")
        
        let (day, hour, _) = NSDate.getTime()
        
        weather.getWeatherInfoForDay(day, hour: hour)
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
        
        updateInfo()
    }
    
    //MARK: SettingsUpdateDelegate
    
    func didUpdateSettings() {
        
        updateInfo()
        
    }
    
    //MARK: UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let page = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        
        pageControl.currentPage = page
    }

    @IBAction func pageControlAction(sender: UIPageControl) {
        
        let page = sender.currentPage
        
        scrollView.scrollRectToVisible(CGRect(x: width * CGFloat(page), y: 0, width: width, height: height), animated: true)
        
    }
    
    @IBAction func showFirstClockAction(sender: UITapGestureRecognizer) {
        
        let p1 = sender.locationInView(view)
        let p2 = scrollView.center
        
        let xDist = p1.x - p2.x
        let yDist = p1.y - p2.y
        let dist = sqrt((xDist * xDist) + (yDist * yDist))
        
        if dist < 100 {
            scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: width, height: height), animated: true)
        }
        
    }
}

extension NSDate {
    
    class func getTime() -> (d: Int, h: Int, m: Int) {
        
        let date = NSDate.init(timeIntervalSinceNow: 0)
        let calendar = NSCalendar.currentCalendar()
        let unit: NSCalendarUnit = [.Day, .Hour, .Minute]
        let comp = calendar.components(unit, fromDate: date)
        
        
        
        return (comp.day, comp.hour, comp.minute)
    }
    
}
