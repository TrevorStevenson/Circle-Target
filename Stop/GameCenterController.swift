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
}
