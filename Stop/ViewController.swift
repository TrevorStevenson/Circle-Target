//
//  ViewController.swift
//  Stop
//
//  Created by Trevor Stevenson on 4/9/15.
//  Copyright (c) 2015 NCUnited. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController {

    var isGameRunning: Bool = false
    var timer = Timer()
    var score = 0
    var time = 0.55
    
    var localPlayer = GKLocalPlayer()
    var gameCenterEnabled: Bool = false
    var leaderBoardIdentifier: String = "highScore2"
    
    var circleFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var centerCircle = Circle(Cframe: CGRect.zero)
    var targetColor = ""
    
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var targetBox: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let defaults = UserDefaults.standard
        
        if (defaults.integer(forKey: "firstTime") == 0)
        {
            let alert = UIAlertController(title: "Welcome", message: "This is Circle Target. Identify and eliminate the target. It's up to you now, soldier.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            defaults.set(1, forKey: "firstTime")
            defaults.set(0, forKey: "highScore")
            defaults.synchronize()
        }
        
        highScoreLabel.text = "High Score: " + String(UserDefaults.standard.integer(forKey: "highScore"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
                
        authenticateLocalPlayer()
        
        scoreLabel.text = "Score: " + String(score)
    }

    @IBAction func leaderboard(_ sender: AnyObject)
    {
        showLeaderboard(leaderBoardIdentifier as NSString)
    }
    
    func check()
    {
        if (centerCircle.fillColor == targetColor)
        {
            score += 1
            
            scoreLabel.text = "Score: " + String(score)
            
            targetLabel.text = "Tap to begin"
            
        }
        else
        {
            targetLabel.text = "Game Over"
            
            time = 0.55
            
            submitScore()
            
            var hScore = UserDefaults.standard.integer(forKey: "highScore")
            
            if (score > hScore)
            {
                hScore = score
                
                UserDefaults.standard.set(hScore, forKey: "highScore")
                
                UserDefaults.standard.synchronize()
            }
            
            highScoreLabel.text = "High Score: " + String(UserDefaults.standard.integer(forKey: "highScore"))
            
            score = 0
            
            scoreLabel.text = "Score: " + String(score)
            
        }
    }

    func placeCircle()
    {
        let screenSize = self.view.frame.size
        
        let radius = arc4random_uniform(UInt32(screenSize.width / 8)) + UInt32(screenSize.width / 8)
        
        let x = arc4random_uniform(UInt32(screenSize.width - (2 * radius) - 40)) + 20
        let y = arc4random_uniform(UInt32(screenSize.height - (2 * radius) - 40)) + 20
        let circle = Circle(Cframe: CGRect(x: x, y: y, width: 2 * radius, height: 2 * radius))
        
        let _ = Timer.scheduledTimer(timeInterval: TimeInterval(radius), target: self, selector: #selector(self.removeCircle(timer:)), userInfo: circle, repeats: false)
    }
    
    func removeCircle(timer: Timer)
    {
        let circle: Circle = timer.userInfo as Circle
        circle.removeFromSuperview()
    }
    
    
    func beginCycle()
    {
        var colors = ["Red", "Orange", "Yellow", "Green", "Blue", "Purple", "Black"]
        
        let random = arc4random_uniform(UInt32(colors.count))
        
        targetColor = colors[Int(random)]
        
    }
    
    func endCycle()
    {
        timer.invalidate()
        
        check()
    }
    
    @IBAction func tapped(_ sender: AnyObject)
    {
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

