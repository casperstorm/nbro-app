//
//  LoginView.swift
//  nbro
//
//  Created by Casper Storm Larsen on 13/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class LoginView: UIView {
    let imageContainerView = UIView()
    let facebookButton = UIButton.facebookButton()
    let backgroundImageView = UIImageView.backgroundImageView()
    let vignetteImageView = UIImageView.vignetteImageView()
    let logoImageView = UIImageView.logoImageView()
    let buttonContainerView = UIView.buttonContainerView()
    let activityIndicatorView = UIActivityIndicatorView.activityIndicatorView()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .blackColor()
        setupSubviews()
        defineLayout()
        
        setNeedsLayout()
        layoutIfNeeded()
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(imageContainerView)
        imageContainerView.addSubview(backgroundImageView)
        imageContainerView.addSubview(vignetteImageView)
        imageContainerView.addSubview(logoImageView)
        addSubview(buttonContainerView)
        buttonContainerView.addSubview(facebookButton)
        buttonContainerView.addSubview(activityIndicatorView)
    }
    
    private func defineLayout() {
        
        imageContainerView.snp_makeConstraints { (make) -> Void in
            make.left.right.top.equalTo(imageContainerView.superview!)
            make.bottom.equalTo(buttonContainerView.snp_top).priorityLow()
        }

        vignetteImageView.snp_updateConstraints { (make) -> Void in
            make.edges.equalTo(vignetteImageView.superview!)
        }
        
        logoImageView.snp_makeConstraints { (make) in
            make.centerX.equalTo(logoImageView.superview!)
            make.top.equalTo(logoImageView.superview!.snp_centerY).multipliedBy(0.24)
        }
        
        buttonContainerView.snp_makeConstraints { (make) in
            make.bottom.left.right.equalTo(buttonContainerView.superview!)
            make.height.equalTo(75).priorityRequired()
        }
        
        facebookButton.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(facebookButton.superview!)
        }
        
        activityIndicatorView.snp_makeConstraints { (make) in
            make.center.equalTo(activityIndicatorView.superview!)
        }
        
    }
    
    override func updateConstraints() {
        
        self.backgroundImageView.snp_updateConstraints { (make) -> Void in
            make.centerY.equalTo(backgroundImageView.superview!)
            make.left.equalTo(backgroundImageView.superview!)
            
            let imageSize = backgroundImageView.image?.size ?? CGSize.zero
            let factor = backgroundImageView.superview!.frame.height / imageSize.height
            
            make.width.equalTo(imageSize.width * factor)
            make.height.equalTo(imageSize.height * factor)
        }
        super.updateConstraints()
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

private extension UIButton {
    static func facebookButton() -> UIButton {
        let facebookButton = UIButton()
        let auth = "Authenticate with "
        let fb = "Facebook"
        let combinedString = auth + fb
        let authRange = NSRange(location: 0, length: auth.characters.count)
        let fbRange = NSRange(location: auth.characters.count, length: fb.characters.count)
        let fbFont = UIFont.defaultBoldFontOfSize(15)
        let authFont = UIFont.defaultLightFontOfSize(15)
        let attrString = NSMutableAttributedString(string: combinedString.uppercaseString)
        attrString.addAttribute(NSFontAttributeName, value: authFont, range: authRange)
        attrString.addAttribute(NSFontAttributeName, value: fbFont, range: fbRange)
        attrString.addAttribute(NSKernAttributeName, value: 1.1, range: fbRange)
        attrString.addAttribute(NSKernAttributeName, value: 1.1, range: authRange)
        
        facebookButton.setAttributedTitle(attrString, forState: .Normal)
        facebookButton.backgroundColor = UIColor.whiteColor()
        facebookButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        return facebookButton
    }
}

private extension UIImageView {
    static func backgroundImageView() -> UIImageView {
        let backgroundImageView = UIImageView(image: UIImage(named: "background_image_2"))
        return backgroundImageView
    }
    static func vignetteImageView() -> UIImageView {
        return UIImageView(image: UIImage(named: "background_vignette"))
    }
    static func logoImageView() -> UIImageView {
        return UIImageView(image: UIImage(named: "nbro_logo_w_detail"))
    }
    
}

private extension UIView {
    static func buttonContainerView() -> UIView {
        let buttonContainerView = UIView()
        buttonContainerView.backgroundColor = UIColor.whiteColor()
        return buttonContainerView
    }
}

private extension UIActivityIndicatorView {
    static func activityIndicatorView() -> UIActivityIndicatorView {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = UIColor.blackColor()
        return activityIndicatorView
    }
}