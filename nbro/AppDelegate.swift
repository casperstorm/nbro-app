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
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FBSDKLoginManager.renewSystemCredentials {
            (result: ACAccountCredentialRenewResult, error: NSError!) -> Void in
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "tokenDidChange", name: FBSDKAccessTokenDidChangeNotification, object: nil)
        
        setupAdditionalStyling()

        let eventListViewController = EventListViewController()
        let loginViewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: eventListViewController)
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = navigationController
        
        Fabric.with([Crashlytics.self])
        
        if (!FacebookManager.authenticated()) {
            LaunchImageView.show()
            self.window?.rootViewController?.presentViewController(loginViewController, animated: false) {
                LaunchImageView.hide()
            }
        } else {
            TrackingManager.trackUser()
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
    
    func tokenDidChange() {
        let accessToken = FBSDKAccessToken.currentAccessToken()
        if accessToken == nil {
            let loginViewController = LoginViewController()
            self.window?.rootViewController?.presentViewController(loginViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: Styling
    
    func setupAdditionalStyling() {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor(hex: 0xffffff)
        navigationBarAppearace.barTintColor = UIColor(hex: 0x000000)
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName: UIFont.defaultBoldFontOfSize(18)]
        
        let backButtonImage = UIImage(named: "back_button")
        navigationBarAppearace.backIndicatorImage = backButtonImage
        navigationBarAppearace.backIndicatorTransitionMaskImage = backButtonImage
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -CGFloat.max), forBarMetrics: .Default)
    }
}

