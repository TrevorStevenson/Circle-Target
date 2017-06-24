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
    var settingsView: UIView?
    var tapGesture: UITapGestureRecognizer!
    var colorSwitch: UISwitch!
    
    
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
        
        let _ = Timer.scheduledTimer(timeInterval: Double(arc4random_uniform(200) + 800) / 1000.0, target: self, selector: #selector(self.extractCircle(timer:)), userInfo: circle, repeats: false)
        
        let delay = Int(arc4random_uniform(400)) + 500
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
        
        let delay = Int(arc4random_uniform(300)) + 800
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
        
        for circle in view.subviews.filter({$0 is Circle})
        {
            circle.removeFromSuperview()
        }
        
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
    
    func hideSettings()
    {
        guard let settings = settingsView else { return }

        settings.flyOutToTop
        {
            self.view.removeGestureRecognizer(self.tapGesture)
            self.settingsButton.isEnabled = true
        }
    }
    
    func didPushSwitch()
    {
        UserDefaults.standard.set(colorSwitch.isOn, forKey: "colorBlind")
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func play(_ sender: UIButton)
    {
        shouldEndGame = false
        nameLabel.fadeOut()
        self.settingsButton.fadeOut()
        hideSettings()
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
        settingsButton.isEnabled = false
        settingsView = UIView(frame: CGRect(x: 10, y: 0, width: view.frame.size.width - 20, height: 60))
        
        guard let settings = settingsView else { return }
        
        settings.backgroundColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        let colorBlindLabel = UILabel(frame: CGRect(x: 30, y: 15, width: 200, height: 150))
        colorBlindLabel.text = "Color blind mode:"
        colorBlindLabel.font = UIFont(name: "Avenir-Book", size: 20)
        colorBlindLabel.textColor = .white
        colorBlindLabel.sizeToFit()
        view.addSubview(settings)
        
        let path = UIBezierPath(roundedRect: settings.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 100, height: 10))
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
        
        settings.flyInFromTop(withDuration: 0.5)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideSettings))
        view.addGestureRecognizer(tapGesture)
            
    }
}

