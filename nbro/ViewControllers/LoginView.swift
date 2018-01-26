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
    let skipButton = UIButton.skipButton()
    let logoImageView = UIImageView.logoImageView()
    let buttonContainerView = UIView.buttonContainerView()
    let activityIndicatorView = UIActivityIndicatorView.activityIndicatorView()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .black
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
    
    fileprivate func setupSubviews() {
        addSubview(imageContainerView)
        imageContainerView.addSubview(logoImageView)
        imageContainerView.addSubview(skipButton)
        addSubview(buttonContainerView)
        buttonContainerView.addSubview(facebookButton)
        buttonContainerView.addSubview(activityIndicatorView)
    }
    
    fileprivate func defineLayout() {
        
        imageContainerView.snp.makeConstraints { (make) -> Void in
            make.left.right.top.equalTo(imageContainerView.superview!)
            make.bottom.equalTo(buttonContainerView.snp.top).priority(10)
        }
        
        logoImageView.snp.makeConstraints { (make) in
            make.center.equalTo(logoImageView.superview!)
            make.width.equalTo(logoImageView.superview!).multipliedBy(0.65)
        }
        
        buttonContainerView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(buttonContainerView.superview!)
            make.height.equalTo(75).priority(1000)
        }
        
        facebookButton.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(facebookButton.superview!)
        }
        
        activityIndicatorView.snp.makeConstraints { (make) in
            make.center.equalTo(activityIndicatorView.superview!)
        }
        
        skipButton.snp.makeConstraints { (make) in
            make.top.equalTo(skipButton.superview!).inset(26)
            make.right.equalTo(skipButton.superview!).inset(15)
        }
        
    }
}

private extension UIButton {
    static func facebookButton() -> UIButton {
        let facebookButton = UIButton()
        let auth = "Authenticate with "
        let fb = "Facebook"
        let combinedString = auth + fb
        let authRange = NSRange(location: 0, length: auth.count)
        let fbRange = NSRange(location: auth.count, length: fb.count)
        let fbFont = UIFont.defaultBoldFontOfSize(15)
        let authFont = UIFont.defaultLightFontOfSize(15)
        let attrString = NSMutableAttributedString(string: combinedString.uppercased())
        attrString.addAttribute(NSAttributedStringKey.font, value: authFont, range: authRange)
        attrString.addAttribute(NSAttributedStringKey.font, value: fbFont, range: fbRange)
        attrString.addAttribute(NSAttributedStringKey.kern, value: 1.1, range: fbRange)
        attrString.addAttribute(NSAttributedStringKey.kern, value: 1.1, range: authRange)
        
        facebookButton.setAttributedTitle(attrString, for: UIControlState())
        facebookButton.backgroundColor = UIColor.white
        facebookButton.setTitleColor(UIColor.black, for: UIControlState())
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        return facebookButton
    }
    static func skipButton() -> UIButton {
        let button = UIButton()
        let title = "SKIP"
        let attrString = NSMutableAttributedString(string: title)
        attrString.addAttribute(NSAttributedStringKey.kern, value: 1.0, range: NSMakeRange(0, title.count))
        attrString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSMakeRange(0, title.count))
        button.setAttributedTitle(attrString, for: UIControlState())
        button.titleLabel?.font = UIFont.defaultMediumFontOfSize(15)
        return button
    }
}

private extension UIImageView {
    static func logoImageView() -> UIImageView {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
}

private extension UIView {
    static func buttonContainerView() -> UIView {
        let buttonContainerView = UIView()
        buttonContainerView.backgroundColor = UIColor.white
        return buttonContainerView
    }
}

private extension UIActivityIndicatorView {
    static func activityIndicatorView() -> UIActivityIndicatorView {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = UIColor.black
        return activityIndicatorView
    }
}
