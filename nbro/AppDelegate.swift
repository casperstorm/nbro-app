//
//  AppDelegate.swift
//  nbro
//
//  Created by Casper Storm Larsen on 02/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FBSDKLoginManager.renewSystemCredentials {
            (result: ACAccountCredentialRenewResult, error: NSError!) -> Void in
        }

        let eventsViewController = EventViewController()
        let loginViewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: eventsViewController)
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = navigationController
        
        if (!FacebookManager.authenticated()) {
            self.window?.rootViewController?.presentViewController(loginViewController, animated: false, completion: nil)
        }
        
        return true
    }
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(
                application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
}

