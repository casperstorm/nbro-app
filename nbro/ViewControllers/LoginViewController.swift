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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        TrackingManager.trackEvent(.viewLogin)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        contentView.animateBackgroundImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)

    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func setupSubviews() {
        contentView.facebookButton.addTarget(self, action: #selector(facebookLoginButtonPressed), for: .touchUpInside)
        contentView.skipButton.addTarget(self, action: #selector(skipLoginButtonPressed), for: .touchUpInside)
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func facebookLoginButtonPressed() {
        contentView.activityIndicatorView.startAnimating()
        contentView.facebookButton.isHidden = true
        FacebookManager.logInWithReadPermissions { (success, error) in
            self.contentView.activityIndicatorView.stopAnimating()
            self.contentView.facebookButton.isHidden = false
            if(success) {
                TrackingManager.trackUser()
                self.dismiss(animated: true, completion: nil)
            } else if (error != nil) {
                let alert = UIAlertController(title: "Error 😞", message: "🐂💩", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func skipLoginButtonPressed() {
        TrackingManager.trackEvent(.skippedLogin)
        self.dismiss(animated: true, completion: nil)
    }
}
