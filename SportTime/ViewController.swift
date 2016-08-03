//
//  ViewController.swift
//  SportTime
//
//  Created by Соболь Евгений on 03.08.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let weather = Weather.sharedWeather
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weather.refresh()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

