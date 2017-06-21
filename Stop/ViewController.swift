//
//  ViewController.swift
//  Stop
//
//  Created by Trevor Stevenson on 4/9/15.
//  Copyright (c) 2015 NCUnited. All rights reserved.
//

import UIKit
import GameKit
import TSCode

class ViewController: UIViewController {

    var score = 0
    
    lazy var localPlayer = GKLocalPlayer()
    var gameCenterEnabled = false
    var leaderBoardIdentifier: String = "highScore2"
    var shouldEndGame = false
    
    var targetCircle: Circle?
    
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var targetBox: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var leaderboardButton: UIButton!
    
    @IBOutlet weak var leaderboardBottom: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        highScoreLabel.text = "High Score: " + String(UserDefaults.standard.integer(forKey: "highScore"))
        setUpMenu()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        authenticateLocalPlayer()
        addToScore(0)
    }

    @IBAction func leaderboard(_ sender: AnyObject)
    {
        showLeaderboard(leaderBoardIdentifier as NSString)
    }
    
    func setUpMenu()
    {
        targetBox.isHidden = true
        targetLabel.isHidden = true
        scoreLabel.isHidden = true
        
        playButton.fadeIn()
        nameLabel.fadeIn()
        settingsButton.fadeIn()
        
        view.layoutIfNeeded()
        leaderboardBottom.constant = 0
        UIView.animate(withDuration: 1) { 
            
            self.view.layoutIfNeeded()
            
        }
        
        playButton.layer.zPosition = 10
        settingsButton.layer.zPosition = 10
        nameLabel.layer.zPosition = 10
        highScoreLabel.layer.zPosition = 10
        leaderboardButton.layer.zPosition = 10

    }
    
    func createTargetCircle() -> Circle
    {
        return Circle(Cframe: targetBox.frame.insetBy(dx: 30, dy: 30).offsetBy(dx: 0, dy: 10))
    }

    func placeCircle()
    {
        if shouldEndGame { return }
        
        let screenSize = self.view.frame.size
        
        let radius = arc4random_uniform(UInt32(screenSize.width / 20)) + UInt32(screenSize.width / 18)
        
        var circle: Circle!
        let circles: [Circle] = view.subviews.filter {$0 is Circle} as! [Circle]
        
        repeat
        {
            let x = arc4random_uniform(UInt32(screenSize.width) - (2 * radius) - 40) + 20
            let y = arc4random_uniform(UInt32(screenSize.height) - (2 * radius) - 60) + 60
            circle = Circle(Cframe: CGRect(x: Int(x), y: Int(y), width: Int(2 * radius), height: Int(2 * radius)))
        }
        while circle.interectingCircles(withCircles: circles).count > 0
        
        self.view.addSubview(circle)
        
        circle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        
        let _ = Timer.scheduledTimer(timeInterval: TimeInterval(radius/8), target: self, selector: #selector(self.extractCircle(timer:)), userInfo: circle, repeats: false)
        
        let delay = Int(arc4random_uniform(1000)) + 100
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) { self.placeCircle() }
    }
    
    func extractCircle(timer: Timer)
    {
        let circle: Circle = timer.userInfo as! Circle
        changeCircle(circle)
    }
    
    func changeCircle(_ circle: Circle)
    {
        //if let target = targetCircle, !shouldEndGame, circle.fillColor == target.fillColor { endGame() }

        guard arc4random_uniform(3) != 0 else
        {
            removeCircle(circle)
            return
        }
        
        circle.setNeedsDisplay()
        
        let delay = Int(arc4random_uniform(500)) + 1000
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) { self.changeCircle(circle) }
    }
    
    func removeCircle(_ circle: Circle)
    {
        circle.removeFromSuperview()
    }
    
    func addToScore(_ value: Int)
    {
        score += value
        scoreLabel.text = "Score: \(score)"
    }
    
    func endGame()
    {
        shouldEndGame = true
        submitScore()
        var hScore = UserDefaults.standard.integer(forKey: "highScore")
        
        if (score > hScore)
        {
            hScore = score
            UserDefaults.standard.set(hScore, forKey: "highScore")
            UserDefaults.standard.synchronize()
        }
        
        highScoreLabel.text = "High Score: " + String(UserDefaults.standard.integer(forKey: "highScore"))
        addToScore(-score)
        
        setUpMenu()
    }
    
    func tap(_ sender: UITapGestureRecognizer)
    {
        guard !shouldEndGame else { return }
        
        let circleView = sender.view as! Circle
        
        guard let target = targetCircle, circleView.fillColor == target.fillColor else
        {
            endGame()
            return
        }
        
        addToScore(1)
        circleView.removeFromSuperview()
    }
    
    @IBAction func play(_ sender: UIButton)
    {
        shouldEndGame = false
        nameLabel.fadeOut()
        self.settingsButton.fadeOut()
        sender.fadeOut(withDuration: 1) {
            
            self.targetCircle = self.createTargetCircle()
            self.targetBox.fadeInAndOut()
            self.targetLabel.fadeInAndOut()
            self.scoreLabel.fadeIn()

            if let circle = self.targetCircle
            {
                self.view.addSubview(circle)
                circle.fadeInAndOut { self.placeCircle() }
            }
            
            self.leaderboardButton.flyOutToBottom(withBottomConstraint: self.leaderboardBottom, duration: 1, andCompletion: {})
        }
    }
    
    @IBAction func settings(_ sender: Any)
    {
        
    }
}

