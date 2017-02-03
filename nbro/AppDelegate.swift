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
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FBSDKLoginManager.renewSystemCredentials { _, _ in }
        
        NotificationCenter.default.addObserver(self, selector: #selector(tokenDidChange), name: NSNotification.Name.FBSDKAccessTokenDidChange, object: nil)
        
        setupAdditionalStyling()

        let loginViewController = LoginViewController()        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = RootViewController()
        self.window?.backgroundColor = UIColor(hex: 0x222222)
        
        Fabric.with([Crashlytics.self])
        
        if (!FacebookManager.authenticated()) {
            LaunchImageView.show()
            self.window?.rootViewController?.present(loginViewController, animated: false) {
                LaunchImageView.hide()
            }
        } else {
            TrackingManager.trackUser()
        }
        
        return true
    }
    
    func application(_ application: UIApplication,
        open url: URL,
        sourceApplication: String?,
        annotation: Any) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(
                application,
                open: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func tokenDidChange() {
        let accessToken = FBSDKAccessToken.current()
        if accessToken == nil {
            presentLoginViewController()
        }
    }
    
    func presentLoginViewController() {
        let loginViewController = LoginViewController()
        self.window?.rootViewController?.present(loginViewController, animated: true, completion: nil)
    }
    
    // MARK: Styling
    
    func setupAdditionalStyling() {
        UIApplication.shared.statusBarStyle = .lightContent
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor(hex: 0xffffff)
        navigationBarAppearace.barTintColor = UIColor(hex: 0x000000)
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName: UIFont.defaultBoldFontOfSize(18)]
        
        let backButtonImage = UIImage(named: "back_button")
        navigationBarAppearace.backIndicatorImage = backButtonImage
        navigationBarAppearace.backIndicatorTransitionMaskImage = backButtonImage
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -CGFloat.greatestFiniteMagnitude), for: .default)
    }
}

