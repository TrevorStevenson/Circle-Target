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
    
    init(Cframe: CGRect, color: String) {
        
        super.init(frame: Cframe)
        
        previousColor = color
        
        self.backgroundColor = UIColor.clear
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
                
        let circlePath = UIBezierPath(ovalIn: rect)
        
        var colors: [UIColor] = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple, UIColor.black]
        
        var random = arc4random_uniform(UInt32(colors.count))
        
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
            
        default:
            fillColor = ""
            break
        }

        while (fillColor == previousColor)
        {
            random = arc4random_uniform(UInt32(colors.count))
            
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
                
            default:
                fillColor = ""
                break
            }

        }
        
        let randomColor: UIColor = colors[Int(random)]
        
        randomColor.setFill()
        
        circlePath.fill()
        
        
    }
    

}
