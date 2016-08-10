//
//  DynamicClockView.swift
//  SportTime
//
//  Created by Соболь Евгений on 05.08.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

import UIKit

@IBDesignable
class DynamicClockView: ClockView {
    
    override func drawRect(rect: CGRect) {
        
        drawClock()
        drawLabels()
        drawMarks()
        drawArrow()
        drawPins()

    }
    
}
