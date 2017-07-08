//
//  Circle.swift
//  Stop
//
//  Created by Trevor Stevenson on 4/9/15.
//  Copyright (c) 2015 NCUnited. All rights reserved.
//

import UIKit
import Foundation
import CodeTrevor

class Circle: UIView {
    
    var colorBlindMode = false
    var colorLabel: UILabel!

    enum CircleColor: String
    { case red = "R", orange = "O", yellow = "Y", green = "G", blue = "B", purple = "P", black = "Bk", cyan = "C", magenta = "M" }
    
    var fillColor: CircleColor?
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    init(Cframe: CGRect) {
        
        super.init(frame: Cframe)

        backgroundColor = UIColor.clear
        scaleUp(withDuration: 0.25, to: 1.25, completion: {})
        colorBlindMode = UserDefaults.standard.bool(forKey: "colorBlind")
        
        colorLabel = UILabel(frame: self.bounds.insetBy(dx: 10, dy: 10))
        colorLabel.font = UIFont(name: "Avenir-Book", size: 40)
        colorLabel.adjustsFontSizeToFitWidth = true
        colorLabel.minimumScaleFactor = 0.01
        colorLabel.textAlignment = .center
        colorLabel.textColor = .black
        self.addSubview(colorLabel)
    }
    
    override func draw(_ rect: CGRect) {

        let circlePath = UIBezierPath(ovalIn: rect)
        setCircleColor()
        circlePath.fill()
        
        if let color = self.fillColor, colorBlindMode
        {
            self.colorLabel.text = color.rawValue
            if color == .black { self.colorLabel.textColor = .white }
            else { self.colorLabel.textColor = .black }
        }
    }
    
    func interectingCircles(withCircles circles: [Circle]) -> [Circle]
    {
        var intersecting: [Circle] = []
        
        for circle in circles
        {
            if self.frame.intersects(circle.frame) { intersecting.append(circle) }
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
