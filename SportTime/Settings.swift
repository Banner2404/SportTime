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
    static var keys: [String] {
        return [tempID, windID, rainID]
    }
    static let InactiveOrder = 999
    static let sharedSettings = Settings()
    weak var delegate: SettingsDelegate?
    
    //TODO: add time
    
//    var temperature: Data
//    var windSpeed: Data
//    var rainChanse: Data
    
    var active = [Data]()
    var passive = [Data]()
    
    override init() {
        super.init()
        update()
    }
    
    func update() {
        
        if delegate != nil {
                        
            active = delegate!.getActive()
            passive = delegate!.getPassive()
            
            active.sortInPlace{ $0.order < $1.order }
            
            saveSettings()

        } else {
            
            loadSettings()
        }
        
        print(active)
        print(passive)

        
    }
    
    //MARK - Save/Load
    
    private func saveSettings() {
        
        let defautls = NSUserDefaults.standardUserDefaults()
        
        for element in active + passive {
            
            let key = element.identifier
            let kMax = key + "max"
            let kMin = key + "min"
            let kOrder = key + "order"
            
            defautls.setInteger(element.max, forKey: kMax)
            defautls.setInteger(element.min, forKey: kMin)
            defautls.setInteger(element.order, forKey: kOrder)

            
        }
        
    }
    
    private func loadSettings() {
        //TODO: first load
        let defautls = NSUserDefaults.standardUserDefaults()
        
        var active = [Data]()
        
        for key in Settings.keys {
            
            let max = defautls.integerForKey(key + "max")
            let min = defautls.integerForKey(key + "min")
            let order = defautls.integerForKey(key + "order")
            
            let data = Data(max: max, min: min, order: order, identifier: key)
            if data.order != Settings.InactiveOrder {
                active.append(data)
            } else {
                passive.append(data)
            }
        }
        
        self.active = active.sort{ $0.order < $1.order }
        
    }
    
    
}

protocol SettingsDelegate: class {
    
    func getActive() -> [Settings.Data]
    func getPassive() -> [Settings.Data]
}

extension Settings {
    
    struct Data {
        
        var max: Int
        var min: Int
        var order: Int
        var identifier: String
        
    }

}


