//
//  Circle.swift
//  Stop
//
//  Created by Trevor Stevenson on 4/9/15.
//  Copyright (c) 2015 NCUnited. All rights reserved.
//

import UIKit
import Foundation
import TSCode

class Circle: UIView {

    enum CircleColor
    { case red, orange, yellow, green, blue, purple, black, cyan, magenta }
    
    var fillColor: CircleColor?
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    init(Cframe: CGRect) {
        
        super.init(frame: Cframe)
        
        self.backgroundColor = UIColor.clear
        scaleUp(withDuration: 0.25, startValue: 1.0, endValue: 1.25, repeatCount: 1, shouldReverse: true)
    }
    
    override func draw(_ rect: CGRect) {

        let circlePath = UIBezierPath(ovalIn: rect)
        setCircleColor()
        circlePath.fill()
    }
    
    func interectingCircles(withCircles circles: [Circle]) -> [Circle]
    {
        var intersecting: [Circle] = []
        
        for circle in circles
        {
            if self.doesIntersect(circle) { intersecting.append(circle) }
        }
        
        return intersecting
    }
    
    func setCircleColor()
    {
        var colors: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple, .black, .cyan, .magenta]
        
        let random = arc4random_uniform(UInt32(colors.count))
        
        let randomColor = colors[Int(random)]
        
        randomColor.setFill()
        
        switch random {
            
        case 0:
            fillColor = .red
        case 1:
            fillColor = .orange
        case 2:
            fillColor = .yellow
        case 3:
            fillColor = .green
        case 4:
            fillColor = .blue
        case 5:
            fillColor = .purple
        case 6:
            fillColor = .black
        case 7:
            fillColor = .cyan
        case 8:
            fillColor = .magenta
        default:
            fillColor = nil
            
        }
    }
}
