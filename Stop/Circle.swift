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

    enum CircleColor {
        case red
        case oragne
        case yellow
        case green
        case blue
        case purple
        case black
        case cyan
        case darkGray
        case magenta
    }
    
    var fillColor: CircleColor?
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    init(Cframe: CGRect) {
        
        super.init(frame: Cframe)
        
        self.backgroundColor = UIColor.clear
        
        let animation = CABasicAnimation(keyPath: "scale")
        animation.fromValue = 1.0
        animation.toValue = 1.5
        self.layer.add(animation, forKey: "scale")
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
        
        let randomColor: UIColor = colors[Int(random)]
        
        randomColor.setFill()
        
        switch random {
            
        case 0:
            self.fillColor = .red
        case 1:
            self.fillColor = .oragne
        case 2:
            self.fillColor = .yellow
        case 3:
            self.fillColor = .green
        case 4:
            self.fillColor = .blue
        case 5:
            self.fillColor = .purple
        case 6:
            self.fillColor = .black
        case 7:
            self.fillColor = .cyan
        case 8:
            self.fillColor = .darkGray
        case 9:
            self.fillColor = .magenta
        default:
            self.fillColor = nil
            
        }
    }
}
