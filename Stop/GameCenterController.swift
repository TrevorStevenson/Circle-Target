//
//  GameCenterController.swift
//  Circle Target
//
//  Created by Trevor Stevenson on 5/29/17.
//  Copyright © 2017 NCUnited. All rights reserved.
//

import Foundation
import GameKit

extension ViewController: GKGameCenterControllerDelegate
{
    func authenticateLocalPlayer()
    {
        localPlayer.authenticateHandler = {(viewController: UIViewController?, error: Error?) in

            if let VC = viewController { self.present(VC, animated: true, completion: nil) }
            else
            {
                self.firstTimeCheck()
                
                self.gameCenterEnabled = GKLocalPlayer.localPlayer().isAuthenticated
                
                guard self.gameCenterEnabled else { return }
                
                GKLocalPlayer.localPlayer().loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardID: String?, error: Error?) -> Void in
                    
                    guard error != nil else { return }
                    
                    if let identifier = leaderboardID { self.leaderBoardIdentifier = identifier }
                })
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
        firstTimeCheck()
    }
    
    func firstTimeCheck()
    {
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
    }
    
    func submitScore()
    {
        let id = "highScore2"
        let highScore = GKScore(leaderboardIdentifier:id)
        
        highScore.value = Int64(score)
        GKScore.report([highScore], withCompletionHandler:nil)
    }
}
