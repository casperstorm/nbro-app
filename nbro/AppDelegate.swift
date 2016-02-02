//
//  AppDelegate.swift
//  nbro
//
//  Created by Casper Storm Larsen on 02/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = EventViewController()
        return true
    }
}

