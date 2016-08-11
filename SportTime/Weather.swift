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
import CoreLocation

class Weather: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var location: CLLocation?
    var data =  [WeatherData]()
    var cachedData = [WeatherData]()
    weak var delegate: WeatherDelegate?
    
    static let sharedWeather = Weather()
    
    func refresh() {
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
        checkLocationAuthorization()
        
    }
    
    func getWeatherInfoForDay(day: Int, hour: Int) {
        
        let filtered = cachedData.filter { $0.time == hour && $0.day == day }
        if !filtered.isEmpty {
            let info = filtered[0]
            let image = getImageForCode(info.imageCode)
            delegate?.didUpdateWeatherInfo(info)
            delegate?.didUpdateWeatherImage(image)
        }
        
    }
    
    //MARK: - Getting data from server
    
    
    private func getHourlyWeatherForLocation(location: CLLocation, onSuccess: (JSON) -> ()) {
        
        let latStr = "\(location.coordinate.latitude)"
        let longStr = "\(location.coordinate.longitude)"
        let coord = latStr + "," + longStr + ".json"
        let baseUrlString = "http://api.wunderground.com/api/892b2fb5ca02a3b4/hourly10day/lang:RU/q/"
        let urlString = baseUrlString + coord
        print(urlString)
        
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

    private func getImageForCode(code: Int) -> UIImage {
        
        var image = UIImage()
        
        switch code {
        case 1, 5, 6, 17:
            image = UIImage(named: "clear")!
        case 2, 3, 7, 8:
            image = UIImage(named: "partly cloudly")!
        case 4:
            image = UIImage(named: "cloudly")!
        case 9, 16, 18, 19, 20, 21, 22, 23, 24:
            image = UIImage(named: "snow")!
        case 10, 11, 12, 13:
            image = UIImage(named: "rain")!
        case 14, 15:
            image = UIImage(named: "thunderstorm")!
        default:
            break
        }
        
        return image
        
    }
    
    private func getDataFrom(json: JSON) -> [WeatherData]  {
        
        var data = [WeatherData]()

        for i in 0..<48 {
            
            let imageCode = json["hourly_forecast"][i]["fctcode"].intValue
            let time = json["hourly_forecast"][i]["FCTTIME"]["hour"].intValue
            let day = json["hourly_forecast"][i]["FCTTIME"]["mday"].intValue
            let temp = json["hourly_forecast"][i]["temp"]["metric"].intValue
            let wind = json["hourly_forecast"][i]["wspd"]["metric"].intValue
            let rain = json["hourly_forecast"][i]["pop"].intValue
            let humidity = json["hourly_forecast"][i]["humidity"].intValue
            let sky = json["hourly_forecast"][i]["sky"].intValue
            
            let weather = WeatherData(imageCode: imageCode, time: time, day: day, temperature: temp,
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
        w[0].time -= 1
        if w[0].time < 0 {
            w[0].time += 24
        }
        return w
    }
    
    private func checkLocationAuthorization() {
    
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .NotDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .Restricted:
            print("location usage restricted")
        default:
            break
        }
        
    }
    
    //MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let newLocation = locations.last
        
        if location == nil || newLocation?.distanceFromLocation(location!) > 100 {
            self.location = newLocation
            self.getHourlyWeatherForLocation(newLocation!) { [unowned self] json in
                self.cachedData = self.getDataFrom(json) //TODO: make caching
                
                if self.delegate != nil {
                    self.delegate!.didUpdateWeather()
                    
                }
                
            }

        }
        locationManager.stopUpdatingLocation()
        

    }
    
}

protocol WeatherDelegate: class {
    
    func didUpdateWeather()
    func didUpdateWeatherImage(image: UIImage)
    func didUpdateWeatherInfo(info: Weather.WeatherData)
    
}

extension Weather {
    
    struct WeatherData {
        
        var imageCode: Int
        var time: Int
        var day: Int
        var temperature: Int
        var windSpeed: Int
        var rainChanse: Int
        var humidity: Int
        var sky: Int
    }
    
    
}