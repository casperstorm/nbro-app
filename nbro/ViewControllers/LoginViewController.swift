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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingManager.trackEvent(.viewLogin)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func setupSubviews() {
        contentView.facebookButton.addTarget(self, action: #selector(facebookLoginButtonPressed), for: .touchUpInside)
        contentView.skipButton.addTarget(self, action: #selector(skipLoginButtonPressed), for: .touchUpInside)
    }
  
    @objc func facebookLoginButtonPressed() {
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
    
    @objc func skipLoginButtonPressed() {
        TrackingManager.trackEvent(.skippedLogin)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.skipLogin(true)
        
        self.dismiss(animated: true, completion: nil)
    }
}
