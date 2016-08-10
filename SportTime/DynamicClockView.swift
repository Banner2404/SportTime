//
//  DynamicClockView.swift
//  SportTime
//
//  Created by Соболь Евгений on 05.08.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

import UIKit

@IBDesignable
class DynamicClockView: UIView {
    
    var startingTime: Int = 0
    
    @IBInspectable var arrow: UIImage?
    
    let boundsInset = CGFloat(40)
    var goodColor = UIColor(red: 0, green: 234.0 / 255, blue: 147.0 / 255, alpha: 1).CGColor
    var mediumColor = UIColor.orangeColor().CGColor
    var badColor = UIColor(red: 1, green: 36.0 / 255, blue: 0, alpha: 1).CGColor
    var orangeColor = UIColor(red: 1, green: 85.0 / 255, blue: 0, alpha: 1)
    
    var lightGoodColor = UIColor(red: 0, green: 234.0 / 255, blue: 147.0 / 255, alpha: 0.4).CGColor
    var lightMediumColor = UIColor(red: 1, green: 85.0 / 255, blue: 0, alpha: 0.4).CGColor
    var lightBadColor = UIColor(red: 238.0 / 255, green: 36.0 / 255, blue: 0, alpha: 0.4).CGColor
    var emptyColor = UIColor.darkGrayColor().CGColor
    
    var clockData: [ClockData.HourlyInfo]?
    let width = CGFloat(60.0)
    let startAngle = -CGFloat(M_PI / 2)
    let deltaAngle = CGFloat(M_PI / 6)
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, width)
        
        let radius = rect.width / 2 - width / 2 - boundsInset
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        
        let time = NSDate.getTime().h
        self.startingTime = time
        let i = getIndexForTime(time, inClockData: clockData)
        
        if let index = i {
            
            for i in index..<(index + 12) {
                
                let data = clockData![i]
                let time = data.time > 11 ? data.time - 12 : data.time
                
                let fromAngle = startAngle + deltaAngle * CGFloat(time)
                let toAngle = startAngle + deltaAngle * CGFloat(time + 1)
                
                CGContextAddArc(context, center.x, center.y, radius, fromAngle , toAngle, 0)
                
                switch data.state {
                case .Good(inTime: true):
                    CGContextSetStrokeColorWithColor(context, goodColor)
                case .Good(inTime: false):
                    CGContextSetStrokeColorWithColor(context, lightGoodColor)
                case .Medium(inTime: true):
                    CGContextSetStrokeColorWithColor(context, mediumColor)
                case .Medium(inTime: false):
                    CGContextSetStrokeColorWithColor(context, lightMediumColor)
                case .Bad(inTime: true):
                    CGContextSetStrokeColorWithColor(context, badColor)
                case .Bad(inTime: false):
                    CGContextSetStrokeColorWithColor(context, lightBadColor)
                }

                CGContextStrokePath(context)
                
                
            }

        } else {
            
            drawEmpty(rect)
        }
        
        drawLabels(rect)
        drawMarks(rect)
        drawArrow(rect)
    }
    
    func drawEmpty(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        let radius = rect.width / 2 - width / 2 - boundsInset
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        
        CGContextSetLineWidth(context, width)
        CGContextSetStrokeColorWithColor(context, emptyColor)
        
        CGContextAddArc(context, center.x, center.y, radius, 0, CGFloat(M_PI * 2), 1)
        
        CGContextStrokePath(context)
        
    }
    
    func drawLabels(rect: CGRect) {
        
        for i in startingTime..<(startingTime + 12) {
            
            let index = i > 11 ? i - 12 : i
            
            let angle = startAngle + CGFloat(index) * deltaAngle
            let labelSize = CGSize(width: 30, height: 30)

            
            let context = UIGraphicsGetCurrentContext()
            CGContextSaveGState(context)
            
            let labelPoint = CGPoint(x: -labelSize.width / 2, y: -labelSize.height / 2)
            
            let labelRect = CGRect(origin: labelPoint, size: labelSize)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .Center
            
            let attrs = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 18)!, NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: UIColor.whiteColor()]
            
            if i == startingTime {
                
                let delta = CGFloat(M_PI) / 25
                
                CGContextTranslateCTM(context, rect.width / 2, rect.height / 2)
                CGContextRotateCTM(context, angle + delta)
                CGContextTranslateCTM(context, 150, 0)
                CGContextRotateCTM(context, -(angle + delta))
                
                var time = i > 23 ? i - 24 : i
                var label: NSString = "\(time)"
                
                label.drawInRect(labelRect, withAttributes: attrs)
                CGContextRestoreGState(context)
                
                CGContextSaveGState(context)
                CGContextTranslateCTM(context, rect.width / 2, rect.height / 2)
                CGContextRotateCTM(context, angle - delta)
                CGContextTranslateCTM(context, 150, 0)
                CGContextRotateCTM(context, -(angle - delta))
                
                time = i + 12 > 23 ? i - 12 : i + 12
                label = "\(time)"
                
                label.drawInRect(labelRect, withAttributes: attrs)


                
            } else {
                
                CGContextTranslateCTM(context, rect.width / 2, rect.height / 2)
                CGContextRotateCTM(context, angle)
                CGContextTranslateCTM(context, 150, 0)
                CGContextRotateCTM(context, -angle)
                
                let time = i > 23 ? i - 24 : i
                let label: NSString = "\(time)"
                
                label.drawInRect(labelRect, withAttributes: attrs)
            }
            
            
            
            CGContextRestoreGState(context)
            
        }
        
        
        
    }
    
    func drawMarks(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        let radius = rect.width / 2 - width / 2 - boundsInset
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let start = radius - width / 2
        let t = NSDate.getTime().h
        let time = t < 12 ? t : t - 12
        
        for i in 0..<12 {
            
            CGContextSaveGState(context)
            CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
            CGContextTranslateCTM(context, center.x, center.y)
            CGContextRotateCTM(context, startAngle + (deltaAngle * CGFloat(i)))
            
            if i == time {
                CGContextMoveToPoint(context, start - 8, 0)
                CGContextAddLineToPoint(context, start + width + 25, 0)
                CGContextSetLineCap(context, CGLineCap.Round)
                CGContextSetLineWidth(context, 3)

            } else {
                CGContextMoveToPoint(context, start + width - 8, 0)
                CGContextAddLineToPoint(context, start + width + 8, 0)
                CGContextSetLineWidth(context, 2)

            }
            
            
            
            CGContextStrokePath(context)
            
            CGContextRestoreGState(context)

        }
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextSetLineWidth(context, 3)
        CGContextAddArc(context, center.x, center.y, radius + width / 2, 0, CGFloat(M_PI * 2), 0)
        CGContextStrokePath(context)

        CGContextSetLineWidth(context, 3)
        CGContextAddArc(context, center.x, center.y, radius - width / 2, 0, CGFloat(M_PI * 2), 0)
        
        CGContextStrokePath(context)
        
        CGContextSetLineWidth(context, 3)
        CGContextAddArc(context, center.x, center.y, 18, 0, CGFloat(M_PI * 2), 0)
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        
        CGContextFillPath(context)
        
        
    }
    
    func drawArrow(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        let (hours, minutes) = NSDate.getTime()
        
        let deltaHours = CGFloat(M_PI / 6)
        let deltaMinutes = CGFloat(M_PI / 360)
        
        let angle = deltaHours * CGFloat(hours) + deltaMinutes * CGFloat(minutes)
        
        CGContextTranslateCTM(context, rect.midX, rect.midY)
        CGContextRotateCTM(context, angle)
        
        let arrowSize = CGFloat(300)
        let arrowRect = CGRect(x: -arrowSize / 2, y: -arrowSize / 2, width: arrowSize, height: arrowSize)
    
        arrow?.drawInRect(arrowRect)
        
    }
    
    func getIndexForTime(time: Int, inClockData data: [ClockData.HourlyInfo]?) -> Int? {
        
        var i = 0
        
        if data == nil {
            return nil
        }
        
        for element in data! {
            
            if element.time == time {
                return i
            } else {
                i += 1
            }
            
        }
        return nil
        
    }
    


}
