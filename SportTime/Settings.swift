//
//  Settings.swift
//  SportTime
//
//  Created by Соболь Евгений on 03.08.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

import UIKit

class Settings: NSObject {
    
    static let tempID = "temperatureCell"
    static let windID = "windCell"
    static let rainID = "rainCell"
    static let InactiveOrder = 999
    static let sharedSettings = Settings()
    weak var delegate: SettingsDelegate?
    
    //TODO: add time
    
    var temperature: Data
    var windSpeed: Data
    var rainChanse: Data
    
    var priority = [Priority]()
    
    override init() {
        
        temperature = Data(max: 30, min: 20, order: 2, identifier: Settings.tempID)
        windSpeed = Data(max: 30, min: 20, order: 1, identifier: Settings.windID)
        rainChanse = Data(max: 30, min: 20, order: 0, identifier: Settings.rainID)
        
        super.init()
        update()
    }
    
    func update() {
        
        if delegate != nil {
            
            temperature = (delegate?.getTemperature())!
            windSpeed = (delegate?.getWindSpeed())!
            rainChanse = (delegate?.getRainChanse())!
            
            priority = [temperature, windSpeed, rainChanse]
            priority.sortInPlace{ $0.order > $1.order }
            
            saveSettings()

        } else {
            
            loadSettings()
        }

        
    }
    
    //MARK - Save/Load
    
    private func saveSettings() {
        
        let defautls = NSUserDefaults.standardUserDefaults()
        
        defautls.setInteger(temperature.min, forKey: "tempMin")
        defautls.setInteger(temperature.max, forKey: "tempMax")
        defautls.setInteger(temperature.order, forKey: "tempOrder")
        
        defautls.setInteger(windSpeed.min, forKey: "windMin")
        defautls.setInteger(windSpeed.max, forKey: "windMax")
        defautls.setInteger(windSpeed.order, forKey: "windOrder")

        defautls.setInteger(rainChanse.min, forKey: "rainMin")
        defautls.setInteger(rainChanse.max, forKey: "rainMax")
        defautls.setInteger(rainChanse.order, forKey: "rainOrder")
        
        
    }
    
    private func loadSettings() {
        
        let defautls = NSUserDefaults.standardUserDefaults()
        
        let tempMin = defautls.integerForKey("tempMin")
        let tempMax = defautls.integerForKey("tempMax")
        let tempOrder = defautls.integerForKey("tempOrder")
        
        let windMin = defautls.integerForKey("windMin")
        let windMax = defautls.integerForKey("windMax")
        let windOrder = defautls.integerForKey("windOrder")
        
        let rainMin = defautls.integerForKey("rainMin")
        let rainMax = defautls.integerForKey("rainMax")
        let rainOrder = defautls.integerForKey("rainOrder")

        temperature = Data(max: tempMax, min: tempMin, order: tempOrder, identifier: Settings.tempID)
        windSpeed = Data(max: windMax, min: windMin, order: windOrder, identifier: Settings.windID)
        rainChanse = Data(max: rainMax, min: rainMin, order: rainOrder, identifier: Settings.rainID)
        
        priority = [temperature, windSpeed, rainChanse].sort{ $0.order < $1.order }
        
    }
    
    
}

protocol SettingsDelegate: class {
    
    func getTemperature() -> Settings.Data
    func getWindSpeed() -> Settings.Data
    func getRainChanse() -> Settings.Data
    
}

protocol Priority {
    
    var order: Int { get set }
    var identifier: String { get }
    
}
extension Settings {
    
    struct Data: Priority {
        
        var max: Int
        var min: Int
        var order: Int
        var identifier: String
        
    }

}


