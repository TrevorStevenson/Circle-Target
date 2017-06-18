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
            
            if let VC = viewController
            {
                self.present(VC, animated: true, completion: nil)
            }
            else
            {
                self.gameCenterEnabled = GKLocalPlayer.localPlayer().isAuthenticated
                
                guard self.gameCenterEnabled else
                {
                    return
                }
                
                GKLocalPlayer.localPlayer().loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardID: String?, error: Error?) -> Void in
                    
                    guard error != nil else
                    {
                        return
                    }
                    
                    if let identifier = leaderboardID
                    {
                        self.leaderBoardIdentifier = identifier
                    }
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
    }
    
    func submitScore()
    {
        let id = "highScore2"
        let highScore = GKScore(leaderboardIdentifier:id)
        
        highScore.value = Int64(score)
        GKScore.report([highScore], withCompletionHandler:nil)
    }
}
