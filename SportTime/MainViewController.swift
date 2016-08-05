//
//  MainViewController.swift
//  SportTime
//
//  Created by Соболь Евгений on 05.08.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    let weather = Weather.sharedWeather
    let settings = Settings.sharedSettings
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weather.refresh()
        settings.update()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
