//
//  LoginViewController.swift
//  nbro
//
//  Created by Casper Storm Larsen on 09/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    lazy var facebookButton: UIButton = {
        let facebookButton = UIButton()
        facebookButton.setTitle("FB Login", forState: .Normal)
        facebookButton.backgroundColor = UIColor.blueColor()
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        facebookButton.addTarget(self, action: "facebookLoginButtonPressed", forControlEvents: .TouchUpInside)
        return facebookButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.setupSubviews()
        self.defineLayout()
    }
    
    func setupSubviews() {
        self.view.addSubview(self.facebookButton)
    }
    
    func defineLayout() {
        let horizontalConstraint = self.facebookButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
        let vertivalConstraint = self.facebookButton.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor)
        let widthConstraint = self.facebookButton.widthAnchor.constraintEqualToConstant(150)
        let heightConstraint = self.facebookButton.heightAnchor.constraintEqualToConstant(47)
        NSLayoutConstraint.activateConstraints([horizontalConstraint, vertivalConstraint, widthConstraint, heightConstraint])
    }
    
    func facebookLoginButtonPressed() {
        FacebookManager.logInWithReadPermissions { (success) in
            if(success) {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}