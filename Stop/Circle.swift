//
//  Circle.swift
//  Stop
//
//  Created by Trevor Stevenson on 4/9/15.
//  Copyright (c) 2015 NCUnited. All rights reserved.
//

import UIKit

class Circle: UIView {

    var fillColor = ""
    var previousColor = "trevor"
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    init(Cframe: CGRect) {
        
        super.init(frame: Cframe)
        
        self.backgroundColor = UIColor.clear
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let circlePath = UIBezierPath(ovalIn: rect)
        
        setCircleColor()
        
        circlePath.fill()
    }
    
    func setCircleColor()
    {
        var colors: [UIColor] = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple, UIColor.black, UIColor.cyan, UIColor.darkGray, UIColor.magenta]
        
        let random = arc4random_uniform(UInt32(colors.count))
        
        switch Int(random)
        {
        case 0:
            fillColor = "Red"
            break
            
        case 1:
            fillColor = "Orange"
            break
            
        case 2:
            fillColor = "Yellow"
            break
            
        case 3:
            fillColor = "Green"
            break
            
        case 4:
            fillColor = "Blue"
            break
            
        case 5:
            fillColor = "Purple"
            break
            
        case 6:
            fillColor = "Black"
            break
            
        case 7:
            fillColor = "Cyan"
            break
            
        case 8:
            fillColor = "DarkGray"
            break
            
        case 9:
            fillColor = "Magenta"
            break
            
        default:
            fillColor = ""
            break
        }
        
        let randomColor: UIColor = colors[Int(random)]
        
        randomColor.setFill()

    }
}
