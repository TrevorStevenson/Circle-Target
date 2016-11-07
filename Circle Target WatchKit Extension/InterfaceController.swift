//
//  InterfaceController.swift
//  Circle Target WatchKit Extension
//
//  Created by Trevor Stevenson on 5/23/15.
//  Copyright (c) 2015 NCUnited. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    var isGameRunning: Bool = false
    var timer = NSTimer()
    var score = 0
    var time = 0.55
    var images: [UIImage] = []
    var colorCellNumber = 0
    
    var targetColor = ""
    var currentColor = "trevor"
    
    @IBOutlet weak var targetLabel: WKInterfaceLabel!
    @IBOutlet weak var scoreLabel: WKInterfaceLabel!
    @IBOutlet weak var watchButton: WKInterfaceButton!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
       images = [UIImage(named: "WatchCircleRed")!, UIImage(named: "WatchCircleOrange")!, UIImage(named: "WatchCircleYellow")!, UIImage(named: "WatchCircleGreen")!, UIImage(named: "WatchCircleBlue")!, UIImage(named: "WatchCirclePurple")!, UIImage(named: "WatchCircleBlack")!]
        
        
        var random = arc4random_uniform(UInt32(images.count))
        
        watchButton.setBackgroundImage(images[Int(random)])
        
        colorCellNumber = Int(random)
        
        scoreLabel.setText("Score: " + String(score))
        
        targetLabel.setText("Tap to begin")
        
        switch Int(random)
        {
        case 0:
            currentColor = "Red"
            break
            
        case 1:
            currentColor = "Orange"
            break
            
        case 2:
            currentColor = "Yellow"
            break
            
        case 3:
            currentColor = "Green"
            break
            
        case 4:
            currentColor = "Blue"
            break
            
        case 5:
            currentColor = "Purple"
            break
            
        case 6:
            currentColor = "Black"
            break
            
        default:
            currentColor = ""
            break
        }

    
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func check()
    {
        if (currentColor == targetColor)
        {
            score++
            
            scoreLabel.setText("Score: " + String(score))
            
            targetLabel.setText("Tap to begin")
            
        }
        else
        {
            targetLabel.setText("Game over. Tap to restart.")
            
            time = 0.55
            
            //submitScore()
            
            var hScore = NSUserDefaults.standardUserDefaults().integerForKey("highScore")
            
            if (score > hScore)
            {
                hScore = score
                
                NSUserDefaults.standardUserDefaults().setInteger(hScore, forKey: "highScore")
                
                NSUserDefaults.standardUserDefaults().synchronize()
            }
            
            score = 0
            
            scoreLabel.setText("Score: " + String(score))
            
        }
    }
    
    
    func beginCycle()
    {
        var colors = ["Red", "Orange", "Yellow", "Green", "Blue", "Purple", "Black"]
        
        var random = arc4random_uniform(UInt32(colors.count))
        
        targetColor = colors[Int(random)]
        
        targetLabel.setText("Target: " + targetColor)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(time), target: self, selector: "changeCircle", userInfo: nil, repeats: true)
    }
    
    func endCycle()
    {
        timer.invalidate()
        
        check()
    }
    
    
    
    func changeCircle()
    {
        var random = arc4random_uniform(UInt32(images.count))
        
        while (Int(random) == colorCellNumber)
        {
            random = arc4random_uniform(UInt32(images.count))
        }
        
        watchButton.setBackgroundImage(images[Int(random)])
        
        colorCellNumber = Int(random)
        
        switch Int(random)
        {
        case 0:
            currentColor = "Red"
            break
            
        case 1:
            currentColor = "Orange"
            break
            
        case 2:
            currentColor = "Yellow"
            break
            
        case 3:
            currentColor = "Green"
            break
            
        case 4:
            currentColor = "Blue"
            break
            
        case 5:
            currentColor = "Purple"
            break
            
        case 6:
            currentColor = "Black"
            break
            
        default:
            currentColor = ""
            break
        }

     
    }


    @IBAction func screenTap() {
        
        if (isGameRunning)
        {

            endCycle()
            
            isGameRunning = false
        }
        else
        {
            beginCycle()
            
            isGameRunning = true
        }
        
    }
}
