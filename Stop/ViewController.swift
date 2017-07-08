//
//  ViewController.swift
//  Stop
//
//  Created by Trevor Stevenson on 4/9/15.
//  Copyright (c) 2015 NCUnited. All rights reserved.
//

import UIKit
import GameKit
import CodeTrevor

class ViewController: UIViewController {

    var score = 0
    
    lazy var localPlayer = GKLocalPlayer()
    var gameCenterEnabled = false
    var leaderBoardIdentifier: String = "highScore2"
    var shouldEndGame = false
    
    var targetCircle: Circle?
    var tapGesture: UITapGestureRecognizer!
    var lavaTap: UITapGestureRecognizer!
    var colorSwitch: UISwitch!
    var lavaSwitch: UISwitch!
    
    var settingsView: UIView?
    var lavaBG: UIImageView!
    
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var targetBox: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var leaderboardButton: UIButton!
    
    @IBOutlet weak var highScoreBottom: NSLayoutConstraint!
    @IBOutlet weak var leaderboardBottom: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        highScoreLabel.text = "High Score: " + String(UserDefaults.standard.integer(forKey: "highScore"))
        
        view.layoutIfNeeded()
        
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
        
        highScoreLabel.flyInFromBottom(toValue: view.bounds.height - leaderboardButton.bounds.height - highScoreLabel.bounds.height - 8, withDuration: 1, useAutoLayout: true, completion: {})
        leaderboardButton.flyInFromBottom(toValue: view.bounds.height - leaderboardButton.bounds.height, withDuration: 1, useAutoLayout: true) {
            
            self.view.isUserInteractionEnabled = true

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
        
        var circle: Circle!
        let circles: [Circle] = view.subviews.filter {$0 is Circle} as! [Circle]
        
        repeat
        {
            let radius = arc4random_uniform(UInt32(screenSize.width / 12)) + UInt32(screenSize.width / 14)
            let x = arc4random_uniform(UInt32(screenSize.width) - (2 * radius) - 40) + 20
            let y = arc4random_uniform(UInt32(screenSize.height) - (2 * radius) - 60) + 60
            circle = Circle(Cframe: CGRect(x: Int(x), y: Int(y), width: Int(2 * radius), height: Int(2 * radius)))
        }
        while circle.interectingCircles(withCircles: circles).count > 0
        
        self.view.addSubview(circle)
        
        circle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        
        let _ = Timer.scheduledTimer(timeInterval: Double(arc4random_uniform(200) + 700) / 1000.0, target: self, selector: #selector(self.extractCircle(timer:)), userInfo: circle, repeats: false)
        
        let delay = Int(arc4random_uniform(400)) + 400
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) { self.placeCircle() }
    }
    
    func extractCircle(timer: Timer)
    {
        let circle: Circle = timer.userInfo as! Circle
        changeCircle(circle)
    }
    
    func changeCircle(_ circle: Circle)
    {
        guard arc4random_uniform(4) != 0, !shouldEndGame else
        {
            circle.removeFromSuperview()
            return
        }
        
        circle.setNeedsDisplay()
        
        let delay = Int(arc4random_uniform(300)) + 700
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay))
        {
            if let target = self.targetCircle, circle.fillColor == target.fillColor, self.view.subviews.contains(circle)
            {
                self.endGame()
            }
            self.changeCircle(circle)
        }
    }
    
    func addToScore(_ value: Int)
    {
        score += value
        scoreLabel.text = "Score: \(score)"
    }
    
    func endGame()
    {
        view.isUserInteractionEnabled = false
        shouldEndGame = true
        
        if UserDefaults.standard.bool(forKey: "lava")
        {
            view.removeGestureRecognizer(lavaTap)
            lavaBG.fadeOut(withDuration: 1, completion: { 
                
                self.lavaBG.removeFromSuperview()

            })
        }
        
        for circle in view.subviews.filter({$0 is Circle})
        {
            circle.removeFromSuperview()
        }
        
        submitScore()
        var hScore = UserDefaults.standard.integer(forKey: "highScore")
        
        hScore = score > hScore ? score : hScore
        UserDefaults.standard.set(hScore, forKey: "highScore")
        UserDefaults.standard.synchronize()
        
        highScoreLabel.text = "High Score: " + String(UserDefaults.standard.integer(forKey: "highScore"))
        addToScore(-score)
        
        scoreLabel.fadeOut(withDuration: 0.5) { 
            
            self.setUpMenu()
            
        }
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
    
    func hideSettings()
    {
        guard let settings = settingsView else { return }

        settings.flyOutToTop(toValue: -settings.bounds.height, withDuration: 1, useAutoLayout: false, completion:
        {
                self.view.removeGestureRecognizer(self.tapGesture)
                self.settingsButton.isEnabled = true
        })
    }
    
    func didPushSwitch()
    {
        UserDefaults.standard.set(colorSwitch.isOn, forKey: "colorBlind")
        UserDefaults.standard.synchronize()
    }
    
    func didPushLavaSwitch()
    {
        UserDefaults.standard.set(lavaSwitch.isOn, forKey: "lava")
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func play(_ sender: UIButton)
    {
        shouldEndGame = false
        nameLabel.fadeOut()
        settingsButton.fadeOut()
        hideSettings()
        leaderboardButton.flyOutToBottom(toValue: view.bounds.height + highScoreLabel.bounds.height + 8, useAutoLayout: true)
        highScoreLabel.flyOutToBottom(toValue: view.bounds.height, useAutoLayout: true)
        
        sender.fadeOut(withDuration: 1) {
            
            self.targetCircle = self.createTargetCircle()
            self.targetBox.fadeInAndOut(withFadeDuration: 2, delay: 1, completion: {})
            self.targetLabel.fadeInAndOut(withFadeDuration: 2, delay: 1, completion: {})
            self.scoreLabel.fadeIn()
            self.scoreLabel.adjustsFontSizeToFitWidth = true
            
            if let circle = self.targetCircle
            {
                self.view.addSubview(circle)
                circle.fadeInAndOut(withFadeDuration: 2, delay: 1, completion:
                {
                    if UserDefaults.standard.bool(forKey: "lava")
                    {
                        self.lavaTap = UITapGestureRecognizer(target: self, action: #selector(self.endGame))
                        self.view.addGestureRecognizer(self.lavaTap)
                        self.lavaBG = UIImageView(image: #imageLiteral(resourceName: "lava"))
                        self.lavaBG.frame = self.view.frame
                        self.lavaBG.layer.zPosition = -10
                        self.view.addSubview(self.lavaBG)
                        self.lavaBG.fadeIn(withDuration: 1, completion:
                        {
                            self.placeCircle()
                        })
                    }
                    else
                    {
                        self.placeCircle()
                    }
                })
            }
        }
    }
    
    @IBAction func settings(_ sender: Any)
    {
        settingsButton.isEnabled = false
        settingsView = UIView(frame: CGRect(x: 10, y: -110, width: view.frame.size.width - 20, height: 110))
        
        guard let settings = settingsView else { return }
        
        settings.backgroundColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        let colorBlindLabel = UILabel(frame: CGRect(x: 30, y: 15, width: 200, height: 150))
        colorBlindLabel.text = "Color blind mode:"
        colorBlindLabel.font = UIFont(name: "Avenir-Book", size: 20)
        colorBlindLabel.textColor = .white
        colorBlindLabel.sizeToFit()
        view.addSubview(settings)
        
        let path = UIBezierPath(roundedRect: settings.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 25, height: 10))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        settings.layer.mask = shapeLayer
        settings.layer.zPosition = 100
        settings.setNeedsDisplay()
        settings.addSubview(colorBlindLabel)
        
        colorSwitch = UISwitch(frame: CGRect(x: settings.frame.width - 71, y: 15, width: 51, height: 31))
        colorSwitch.addTarget(self, action: #selector(didPushSwitch), for: .valueChanged)
        colorSwitch.setOn(UserDefaults.standard.bool(forKey: "colorBlind"), animated: false)
        settings.addSubview(colorSwitch)
        
        let lavaModeLabel = UILabel(frame: CGRect(x: 30, y: colorBlindLabel.frame.origin.y + colorBlindLabel.bounds.height + 20, width: 200, height: 150))
        lavaModeLabel.text = "Lava mode:"
        lavaModeLabel.font = UIFont(name: "Avenir-Book", size: 20)
        lavaModeLabel.textColor = .white
        lavaModeLabel.sizeToFit()
        settings.addSubview(lavaModeLabel)

        lavaSwitch = UISwitch(frame: CGRect(x: settings.frame.width - 71, y: colorBlindLabel.frame.origin.y + colorBlindLabel.bounds.height + 20, width: 51, height: 31))
        lavaSwitch.addTarget(self, action: #selector(didPushLavaSwitch), for: .valueChanged)
        lavaSwitch.setOn(UserDefaults.standard.bool(forKey: "lava"), animated: false)
        settings.addSubview(lavaSwitch)
        
        settings.flyInFromTop(toValue: 0, withDuration: 0.75, completion: {})
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideSettings))
        view.addGestureRecognizer(tapGesture)
    }
}

