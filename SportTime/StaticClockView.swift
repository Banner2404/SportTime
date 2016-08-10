//
//  StaticClockView.swift
//  SportTime
//
//  Created by Соболь Евгений on 10.08.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

import UIKit

class StaticClockView: ClockView {

    var startingTime = 0
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        day += 1
        hour = startingTime
        
        drawClock()
        drawLabels()
        drawMarks()
        drawPins()
        
    }

}
