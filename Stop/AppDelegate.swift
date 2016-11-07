//
//  AppDelegate.swift
//  Stop
//
//  Created by Trevor Stevenson on 4/9/15.
//  Copyright (c) 2015 NCUnited. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AdColonyDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        AdColony.configure(withAppID: "appdb7d71c5c0094d4086", zoneIDs: ["vzc56598c137ce43eebd", "vz48d363dee8ab40a7aa"], delegate: self, logging: true)
        
        let defaults = UserDefaults.standard
        
        if (defaults.integer(forKey: "firstTime") == 0)
        {
            let alert = UIAlertView(title: "Welcome", message: "This is Circle Target. Tap to begin the cycle. Tap again to stop. The goal is to stop on the specified target color. Check out your high score on the global leaderboards.", delegate: self, cancelButtonTitle: "Got it")
            
            alert.show()
            
            defaults.set(1, forKey: "firstTime")
            
            defaults.set(0, forKey: "highScore")
            
            defaults.synchronize()
        }
        
        
        return true
    }

    func onAdColonyV4VCReward(_ success: Bool, currencyName: String!, currencyAmount amount: Int32, inZone zoneID: String!) {
        
        if (success)
        {
            UserDefaults.standard.set(true, forKey: "addPoints")
            
            UserDefaults.standard.synchronize()
        }
        else
        {
            print("error")
        }
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

