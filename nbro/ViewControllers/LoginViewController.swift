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
        let fbFont = UIFont.defaultBoldFontOfSize(15)
        let authFont = UIFont.defaultFontOfSize(15)
        let attrString = NSMutableAttributedString(string: combinedString.uppercaseString)
        attrString.addAttribute(NSFontAttributeName, value: authFont, range: authRange)
        attrString.addAttribute(NSFontAttributeName, value: fbFont, range: fbRange)
        attrString.addAttribute(NSKernAttributeName, value: 1.1, range: fbRange)
        attrString.addAttribute(NSKernAttributeName, value: 1.1, range: authRange)

        facebookButton.setAttributedTitle(attrString, forState: .Normal)
        facebookButton.backgroundColor = UIColor.whiteColor()
        facebookButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        facebookButton.addTarget(self, action: "facebookLoginButtonPressed", forControlEvents: .TouchUpInside)
        return facebookButton
    }()
    let backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView(image: UIImage(named: "login_background_image_1"))
        return backgroundImageView
    }()
    let imageContainerView = UIView()
    let vignetteImageView: UIImageView = {
        return UIImageView(image: UIImage(named: "background_vignette"))
    }()
    let logoImageView: UIImageView = {
        let logoImageView = UIImageView(image: UIImage(named: "nbro_logo_w_detail"))
        return logoImageView
    }()
    let buttonContainerView: UIView = {
        let buttonContainerView = UIView()
        buttonContainerView.backgroundColor = UIColor.whiteColor()
        return buttonContainerView
    }()
    let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = UIColor.blackColor()
        return activityIndicatorView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        defineLayout()
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        view.setNeedsUpdateConstraints()
        view.updateConstraintsIfNeeded()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    func applicationWillEnterForeground() {
        animateBackgroundImage()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillEnterForeground", name: UIApplicationWillEnterForegroundNotification, object: nil)
        animateBackgroundImage()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillEnterForegroundNotification, object: nil)
    }

    func setupSubviews() {
        view.addSubview(imageContainerView)
        imageContainerView.addSubview(backgroundImageView)
        imageContainerView.addSubview(vignetteImageView)
        imageContainerView.addSubview(logoImageView)
        view.addSubview(buttonContainerView)
        buttonContainerView.addSubview(facebookButton)
        buttonContainerView.addSubview(activityIndicatorView)
    }
    
    func defineLayout() {
        facebookButton.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(facebookButton.superview!)
        }
        
        imageContainerView.snp_makeConstraints { (make) -> Void in
            make.left.right.top.equalTo(imageContainerView.superview!)
            make.bottom.equalTo(facebookButton.snp_top)
        }
        
        vignetteImageView.snp_updateConstraints { (make) -> Void in
            make.edges.equalTo(vignetteImageView.superview!)
        }
        
        logoImageView.snp_makeConstraints { (make) in
            make.centerX.equalTo(logoImageView.superview!)
            make.top.equalTo(logoImageView.superview!.snp_centerY).multipliedBy(0.24)
        }
        
        activityIndicatorView.snp_makeConstraints { (make) in
            make.center.equalTo(activityIndicatorView.superview!)
        }
        
        buttonContainerView.snp_makeConstraints { (make) in
            make.width.bottom.left.equalTo(self.view)
            make.height.equalTo(75)
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
        activityIndicatorView.startAnimating()
        facebookButton.hidden = true
        FacebookManager.logInWithReadPermissions { (success) in
            self.activityIndicatorView.stopAnimating()
            self.facebookButton.hidden = false
            if(success) {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    // MARK : Animation
    
    func animateBackgroundImage() {
        let offset = backgroundImageView.frame.width - backgroundImageView.superview!.frame.width
        
        UIView.animateWithDuration(90.0, delay: 0, options: [.Autoreverse, .Repeat, .CurveLinear], animations: { () -> Void in
            self.backgroundImageView.transform = CGAffineTransformMakeTranslation(-offset, 0)

            }) { (finished) -> Void in
                self.backgroundImageView.transform = CGAffineTransformIdentity
        }
    
    }
}