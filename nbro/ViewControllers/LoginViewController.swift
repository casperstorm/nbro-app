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
    lazy var facebookButton: UIButton = {
        let facebookButton = UIButton()
        let auth = "Authenticate with "
        let fb = "Facebook"
        let combinedString = auth + fb
        let authRange = NSRange(location: 0, length: auth.characters.count)
        let fbRange = NSRange(location: auth.characters.count, length: fb.characters.count)
        let fbFont = UIFont.boldSystemFontOfSize(14)
        let authFont = UIFont.systemFontOfSize(14)
        let attrString = NSMutableAttributedString(string: combinedString)
        attrString.addAttribute(NSFontAttributeName, value: authFont, range: authRange)
        attrString.addAttribute(NSFontAttributeName, value: fbFont, range: fbRange)
        
        facebookButton.setAttributedTitle(attrString, forState: .Normal)
        facebookButton.backgroundColor = UIColor.whiteColor()
        facebookButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        facebookButton.addTarget(self, action: "facebookLoginButtonPressed", forControlEvents: .TouchUpInside)
        return facebookButton
    }()
    lazy var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView(image: UIImage(named: "temp_login_background"))
//        backgroundImageView.contentMode = .Left //.ScaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundImageView
    }()
    let imageContainerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkGrayColor()
        
        setupSubviews()
        defineLayout()
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        view.setNeedsUpdateConstraints()
        view.updateConstraintsIfNeeded()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        animateBackgroundImage()

    }

    func setupSubviews() {
        view.addSubview(imageContainerView)
        imageContainerView.addSubview(backgroundImageView)
        self.view.addSubview(self.facebookButton)
    }
    
    func defineLayout() {
        self.facebookButton.snp_makeConstraints { (make) -> Void in
            make.width.bottom.left.equalTo(self.view)
            make.height.equalTo(75)
        }
        
        imageContainerView.snp_makeConstraints { (make) -> Void in
            make.left.right.top.equalTo(imageContainerView.superview!)
            make.bottom.equalTo(facebookButton.snp_top)
        }
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        self.backgroundImageView.snp_updateConstraints { (make) -> Void in
            make.centerY.equalTo(backgroundImageView.superview!)
            make.left.equalTo(backgroundImageView.superview!)

            let imageSize = backgroundImageView.image?.size ?? CGSize.zero
            let factor = backgroundImageView.superview!.frame.height / imageSize.height
            
            make.width.equalTo(imageSize.width * factor)
            make.height.equalTo(imageSize.height * factor)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func facebookLoginButtonPressed() {
        FacebookManager.logInWithReadPermissions { (success) in
            if(success) {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    // MARK : Animation
    
    func animateBackgroundImage() {
        let offset = backgroundImageView.frame.width - backgroundImageView.superview!.frame.width
        
        UIView.animateWithDuration(30.0, delay: 0, options: [.Autoreverse, .Repeat, .CurveLinear], animations: { () -> Void in
            self.backgroundImageView.transform = CGAffineTransformMakeTranslation(-offset, 0)

            }) { (finished) -> Void in
                
        }
    
    }
    
}