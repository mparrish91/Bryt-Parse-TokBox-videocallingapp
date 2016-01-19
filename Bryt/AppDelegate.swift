//
//  AppDelegate.swift
//  Bryt
//
//  Created by Malcolm Parrish on 10/30/15.
//  Copyright © 2015 Bryt. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var userTitle: String?
    
    var callerTitle: String?
    var sessionID: String?
    var publisherToken: String?
    var subscriberToken: String?
    
    var bFullyLoggedIn: Bool?
    
    var currentLocation: CLLocation?
    weak var appTimer: NSTimer?
    



    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("iirMSp4mpvmgnGGKtqPd92OiiHAXqjEroqzsbzbX",
            clientKey: "fPKkRUDiF5alWT2TFm5vp5cppfqIkJVp3zVIy0ek")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        bFullyLoggedIn = false
        ParseHelper.initData()
        registerNotifs()
        
        
        return true
    }
    
    func registerNotifs() {
        
        //if they have logged in run this skip
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        var firstVC = storyboard.instantiateViewControllerWithIdentifier("navvc") as! UINavigationController
        self.window?.rootViewController = firstVC
        
    }


    func applicationDidEnterBackground(application: UIApplication) {
        
        var backgroundTask = application.beginBackgroundTaskWithExpirationHandler {(
            application.endBackgroundTask(UIBackgroundTaskInvalid))
//            backgroundTask = UIBackgroundTaskInvalid

            
            //Start the long-running task and return immediately
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                
                ParseHelper.deleteActiveSession()
                ParseHelper.deleteActiveUser()
//                backgroundTask = UIBackgroundTaskInvalid

            })
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        self.bFullyLoggedIn = false
        ParseHelper.anonymousLogin()
        ParseHelper.initData()
        
    }

    
    func fireListeningTimer() {
        
        if (appTimer == nil){
            return
                appTimer = NSTimer.scheduledTimerWithTimeInterval(8.0,target: self,selector: Selector("onTick:"),userInfo: nil, repeats: true)
            
            ParseHelper.setPollingTimer(true)
            print("fired timer")
        }
    }
    
    func onTick(timer: NSTimer){
        print("onTick")
        ParseHelper.pollParseForActiveSessions()
    }
    
}

