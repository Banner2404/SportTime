//
//  ClockView.swift
//  SportTime
//
//  Created by Соболь Евгений on 10.08.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

import UIKit
@IBDesignable
class ClockView: UIView {
    
    // clock arrow
    @IBInspectable var arrow: UIImage?
    
    // data
    var clockData: [ClockData.HourlyInfo]?
    
    // colors
    let emptyColor = UIColor.grayColor()
    let goodColor = UIColor.greenColor()
    let mediumColor = UIColor.orangeColor()
    let badColor = UIColor.redColor()
    let whiteColor = UIColor.whiteColor()
    let orangeColor = UIColor.orangeColor()
    
    // angles
    let startAngle = -CGFloat(M_PI / 2)
    let deltaAngle = CGFloat(M_PI / 6)
    
    // date
    var (day, hour, min) = NSDate.getTime()
    
    // parameters
    let pinRadius = CGFloat(10)
    let labelsInset = CGFloat(25)
    let frameInset = CGFloat(40)
    let width = CGFloat(50)
    var radius: CGFloat {
        return bounds.width / 2 - width / 2 - frameInset
    }
    var boundsCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    override func drawRect(rect: CGRect) {
        (day, hour, min) = NSDate.getTime()
    }
    
    func drawClock() {
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        var angle = startAngle + CGFloat(hour) * deltaAngle
        
        for time in hour..<(hour + 12) {
            
            let index = getIndexForDay(day, andHour: time, inClockData: clockData)
            var color = emptyColor.CGColor
            var strokeColor = whiteColor.CGColor
            var strokeWidth = CGFloat(0)
            
            if let index = index {
                
                let data = clockData![index]
                
                switch data.state {
                case .Good(inTime: true):
                    color = goodColor.CGColor
                    strokeColor = UIColor.blueColor().CGColor
                    strokeWidth = 5
                case .Good(inTime: false):
                    color = goodColor.CGColor
                    strokeColor = whiteColor.CGColor
                    strokeWidth = 3
                case .Medium(inTime: true):
                    color = mediumColor.CGColor
                    strokeColor = UIColor.blueColor().CGColor
                    strokeWidth = 5
                case .Medium(inTime: false):
                    color = mediumColor.CGColor
                    strokeColor = whiteColor.CGColor
                    strokeWidth = 3
                case .Bad(inTime: true):
                    color = badColor.CGColor
                    strokeColor = UIColor.blueColor().CGColor
                    strokeWidth = 5
                case .Bad(inTime: false):
                    color = badColor.CGColor
                    strokeColor = whiteColor.CGColor
                    strokeWidth = 3
                }
                
            }
            
            CGContextAddArc(context, boundsCenter.x, boundsCenter.y, radius, angle, angle + deltaAngle + 0.01, 0)
            CGContextSetStrokeColorWithColor(context, color)
            CGContextSetLineWidth(context, width)
            CGContextStrokePath(context)
            
            CGContextAddArc(context, boundsCenter.x, boundsCenter.y, radius + width / 2, angle, angle + deltaAngle + 0.01, 0)
            CGContextSetStrokeColorWithColor(context, strokeColor)
            CGContextSetLineWidth(context, strokeWidth)
            CGContextStrokePath(context)

            angle += deltaAngle
            
        }
        
        
        CGContextRestoreGState(context)
        
    }
    
    func drawLabels() {
        
        var angle = startAngle + CGFloat(hour) * deltaAngle
        let delta = CGFloat(M_PI) / 25
        
        var time = hour + 12 > 23 ? hour - 12 : hour + 12
        var str: NSString = "\(time)"
        drawLabel(str, atAngle: angle - delta)
        
        time = hour
        str = "\(time)"
        drawLabel(str, atAngle: angle + delta)
        
        for i in (hour + 1)..<(hour + 12) {
            
            angle += deltaAngle
            
            time = i > 23 ? i - 24 : i
            str = "\(time)"
            
            drawLabel(str, atAngle: angle)
            
        }
        
        
        
    }
    
    private func drawLabel(str: NSString, atAngle angle: CGFloat) {
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        let labelSize = CGSize(width: 30, height: 30)
        let labelPoint = CGPoint(x: -labelSize.width / 2, y: -labelSize.height / 2)
        let labelRect = CGRect(origin: labelPoint, size: labelSize)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        let attrs = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 18)!, NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: UIColor.whiteColor()]


        CGContextTranslateCTM(context, boundsCenter.x, boundsCenter.y)
        CGContextRotateCTM(context, angle)
        CGContextTranslateCTM(context, radius + width / 2 + labelsInset, 0)
        CGContextRotateCTM(context, -angle)
        
        str.drawInRect(labelRect, withAttributes: attrs)
        
        CGContextRestoreGState(context)

    }
    
    func drawMarks() {
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        var angle = startAngle + CGFloat(hour) * deltaAngle
        
        drawMarkAtAngle(angle, isLarge: true)
        
        for _ in (hour + 1)..<(hour + 12) {
            angle += deltaAngle

            drawMarkAtAngle(angle, isLarge: false)
            
        }
        
        CGContextSetStrokeColorWithColor(context, whiteColor.CGColor)
        CGContextSetLineWidth(context, 3)
        CGContextAddArc(context, boundsCenter.x, boundsCenter.y, radius - width / 2, 0, CGFloat(M_PI * 2), 0)
        
        CGContextStrokePath(context)
        
        CGContextAddArc(context, boundsCenter.x, boundsCenter.y, 18, 0, CGFloat(M_PI * 2), 0)
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        
        CGContextFillPath(context)

        
        CGContextRestoreGState(context)

    }
    
    private func drawMarkAtAngle(angle: CGFloat, isLarge: Bool) {
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        CGContextTranslateCTM(context, boundsCenter.x, boundsCenter.y)
        CGContextRotateCTM(context, angle)
        CGContextSetStrokeColorWithColor(context, whiteColor.CGColor)
        
        if isLarge {
            CGContextMoveToPoint(context, radius - width / 2 - 8, 0)
            CGContextAddLineToPoint(context, radius + width / 2 + 25, 0)
            CGContextSetLineCap(context, CGLineCap.Round)
            CGContextSetLineWidth(context, 3)
        } else {
            CGContextMoveToPoint(context, radius + width / 2 - 8, 0)
            CGContextAddLineToPoint(context, radius + width / 2 + 8, 0)
            CGContextSetLineWidth(context, 3)
        }
        
        CGContextStrokePath(context)
        
        CGContextRestoreGState(context)
    }
    
    
    
    func drawArrow() {
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        let deltaHours = CGFloat(M_PI / 6)
        let deltaMinutes = CGFloat(M_PI / 360)
        
        let angle = deltaHours * CGFloat(hour) + deltaMinutes * CGFloat(min)
        
        CGContextTranslateCTM(context, boundsCenter.x, boundsCenter.y)
        CGContextRotateCTM(context, angle)
        
        let arrowSize = CGFloat(300)
        let arrowRect = CGRect(x: -arrowSize / 2, y: -arrowSize / 2, width: arrowSize, height: arrowSize)
        
        arrow?.drawInRect(arrowRect)
        CGContextRestoreGState(context)
        
    }
    
    func drawPins() {
        
        let settings = Settings.sharedSettings
        let min = settings.time.min
        let max = settings.time.max
        var angle = startAngle + CGFloat(hour) * deltaAngle
        
        for i in hour..<(hour + 12) {
            
            let time = i > 23 ? i - 24: i
            if time == min || time == max {
                
                drawPinAtAngle(angle)
            }
            angle += deltaAngle
            
        }
        
       
    }
    
    private func drawPinAtAngle(angle: CGFloat) {
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        CGContextTranslateCTM(context, boundsCenter.x, boundsCenter.y)
        CGContextRotateCTM(context, angle)
        
        CGContextTranslateCTM(context, radius + width / 2, 0)
        
        CGContextAddArc(context, 0, 0, pinRadius, 0, CGFloat(M_PI * 2), 0)
        
        CGContextSetFillColorWithColor(context, UIColor.blueColor().CGColor)
        
        CGContextFillPath(context)
        
        CGContextRestoreGState(context)
    }

    
    func getIndexForDay(day: Int, andHour hour: Int, inClockData data: [ClockData.HourlyInfo]?) -> Int? {
        
        var day = day
        var hour = hour
        
        while hour > 23 {
            hour -= 24
            day += 1
        }
        
        while hour < 0 {
            hour += 24
            day -= 1
        }
        
        var i = 0
        
        if data == nil {
            return nil
        }
        
        for element in data! {
            
            if element.day == day && element.time == hour {
                return i
            } else {
                i += 1
            }
            
        }
        return nil
        
    }



}
