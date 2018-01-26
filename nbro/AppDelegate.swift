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
        
        if (showLoginViewController()) {
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
    
    @objc func tokenDidChange() {
        let accessToken = FBSDKAccessToken.current()
        if accessToken == nil {
            presentLoginViewController()
        }
    }
    
    func presentLoginViewController() {
        let loginViewController = LoginViewController()
        self.window?.rootViewController?.present(loginViewController, animated: true, completion: nil)
    }
}

extension AppDelegate {
    func setupAdditionalStyling() {
        UIApplication.shared.statusBarStyle = .default
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = .white
        navigationBarAppearace.barTintColor = .black
        navigationBarAppearace.isTranslucent = false
        navigationBarAppearace.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font: UIFont.defaultBoldFontOfSize(19)]
        
        UITabBar.appearance().tintColor = .black
        UITabBar.appearance().barTintColor = .black
        
        let backButtonImage = #imageLiteral(resourceName: "back_button")

        navigationBarAppearace.backIndicatorImage = backButtonImage
        navigationBarAppearace.backIndicatorTransitionMaskImage = backButtonImage

        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-200, 0), for: .default)
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSAttributedStringKey.font: UIFont.defaultSemiBoldFontOfSize(14),
            NSAttributedStringKey.foregroundColor: UIColor(hex: 0x000000),
            NSAttributedStringKey.kern: 1.0
            ], for: .normal)
    }
}

extension AppDelegate {
    func skipLogin(_ skip: Bool) {
        UserDefaults.standard.set(skip, forKey: "nbro_skip_login_key")
        UserDefaults.standard.synchronize()
    }
    
    func showLoginViewController() -> Bool {
        let skip: Bool = UserDefaults.standard.bool(forKey: "nbro_skip_login_key")
        let auth: Bool = FacebookManager.authenticated()
        
        return skip ? !skip : !auth
    }
}

