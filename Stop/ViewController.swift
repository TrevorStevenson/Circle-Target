//
//  ViewController.swift
//  Stop
//
//  Created by Trevor Stevenson on 4/9/15.
//  Copyright (c) 2015 NCUnited. All rights reserved.
//

import UIKit
import iAd
import GameKit

class ViewController: UIViewController, ADBannerViewDelegate, GKGameCenterControllerDelegate {

    var isGameRunning: Bool = false
    var timer = Timer()
    var score = 0
    var time = 0.55
    
    var localPlayer = GKLocalPlayer()
    var gameCenterEnabled: Bool = false
    var leaderBoardIdentifier: String = "highScore2"
    
    var circleFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var centerCircle = Circle(Cframe: CGRect.zero, color: "trevor")
    var targetColor = ""
    
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var side: CGFloat = 200
        
        if (self.view.bounds.size.height == 480)
        {
            side = 150
        }
        
        let cSize = self.view.frame.size
        circleFrame = CGRect(x: cSize.width/2 - CGFloat(side/2), y: cSize.height/2 - CGFloat(side/2), width: side, height: side)
        
        centerCircle = Circle(Cframe: circleFrame, color: "trevor")
        
        self.view.addSubview(centerCircle)
        
        scoreLabel.text = "Score: " + String(score)
        
        targetLabel.text = "Tap to begin"
        
        highScoreLabel.text = "High Score: " + String(UserDefaults.standard.integer(forKey: "highScore"))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
                
        authenticateLocalPlayer()
        
        if (UserDefaults.standard.bool(forKey: "addPoints"))
        {
            score += 2
            UserDefaults.standard.set(false, forKey: "addPoints")
            UserDefaults.standard.synchronize()
        }
        
        scoreLabel.text = "Score: " + String(score)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bannerViewDidLoadAd(_ banner: ADBannerView!) {
        
        UIView.beginAnimations(nil, context: nil)
    
        UIView.setAnimationDuration(1.0)
    
        banner.alpha = 1.0
    
        UIView.commitAnimations()
  
        
    }
    
    func bannerView(_ banner: ADBannerView!, didFailToReceiveAdWithError error: Error!) {
        
        UIView.beginAnimations(nil, context: nil)
    
        UIView.setAnimationDuration(1.0)
    
        banner.alpha = 0.0
    
        UIView.commitAnimations()
   
    }
    

    func authenticateLocalPlayer()
    {
        localPlayer.authenticateHandler = {(viewController: UIViewController?, error: Error?) in
            
            if (viewController != nil)
            {
                self.present(viewController!, animated: true, completion: nil)
            }
            else
            {
                if (GKLocalPlayer.localPlayer().isAuthenticated)
                {
                    self.gameCenterEnabled = true
                    
                    GKLocalPlayer.localPlayer().loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifier: String?, error: Error?) -> Void in
                        
                        if (error != nil)
                        {
                            print(error!.localizedDescription)
                        }
                        else
                        {
                            self.leaderBoardIdentifier = leaderboardIdentifier!
                            
                            GKNotificationBanner.show(withTitle: "Welcome", message: "Get a high score!", completionHandler: { () -> Void in
                                
                            })
                        }
                    })
                    
                }
                else
                {
                    self.gameCenterEnabled = false
                }
            }
            
        }

    }
        
    func showLeaderboard(_ identifier: NSString)
    {
        let GKVC = GKGameCenterViewController()
        
        GKVC.gameCenterDelegate = self
        
        GKVC.viewState = GKGameCenterViewControllerState.leaderboards
        
        GKVC.leaderboardIdentifier = identifier as String
        
        present(GKVC, animated: true, completion: nil)
            
    }
        
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController)
    {
        dismiss(animated: true, completion: nil)
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

    
    func beginCycle()
    {
        var colors = ["Red", "Orange", "Yellow", "Green", "Blue", "Purple", "Black"]
        
        let random = arc4random_uniform(UInt32(colors.count))
        
        targetColor = colors[Int(random)]
        
        targetLabel.text = "Target: " + targetColor
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(time), target: self, selector: #selector(ViewController.changeCircle), userInfo: nil, repeats: true)
    }
    
    func endCycle()
    {
        timer.invalidate()
        
        check()
    }
    
   
    
    func changeCircle()
    {
        let color  = centerCircle.fillColor
        
        centerCircle.removeFromSuperview()
        
        centerCircle = Circle(Cframe: circleFrame, color: color)
        
        self.view.addSubview(centerCircle)
    }
    
    func submitScore()
    {
        let id: String = "highScore2"
        
        let highScore = GKScore(leaderboardIdentifier:id)
        
        highScore.value = Int64(score)
        
        GKScore.report([highScore], withCompletionHandler: { (error: Error?) -> Void in
            
            if (error != nil)
            {
                print(error!.localizedDescription)
            }
        })
        
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

