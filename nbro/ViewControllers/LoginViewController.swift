//
//  LoginViewController.swift
//  nbro
//
//  Created by Casper Storm Larsen on 09/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class LoginViewController: UIViewController {

    var contentView = LoginView()
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    func applicationWillEnterForeground() {
        contentView.animateBackgroundImage()
    }
    
    func applicationDidEnterBackground() {
        contentView.stopBackgroundAnimation()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillEnterForeground", name: UIApplicationWillEnterForegroundNotification, object: nil)
        contentView.animateBackgroundImage()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillEnterForegroundNotification, object: nil)

    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func setupSubviews() {
        contentView.facebookButton.addTarget(self, action: "facebookLoginButtonPressed", forControlEvents: .TouchUpInside)
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func facebookLoginButtonPressed() {
        contentView.activityIndicatorView.startAnimating()
        contentView.facebookButton.hidden = true
        FacebookManager.logInWithReadPermissions { (success, error) in
            self.contentView.activityIndicatorView.stopAnimating()
            self.contentView.facebookButton.hidden = false
            if(success) {
                TrackingManager.trackUser()
                self.dismissViewControllerAnimated(true, completion: nil)
            } else if (error != nil) {
                let alert = UIAlertController(title: "Error 😞", message: "🐂💩", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
}