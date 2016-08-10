//
//  StaticClockView.swift
//  SportTime
//
//  Created by Соболь Евгений on 10.08.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

import UIKit

class StaticClockView: ClockView {

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        day += 1
        hour = 12
        
        drawClock()
        drawLabels()
        drawMarks()
        drawPins()
        
    }

}
