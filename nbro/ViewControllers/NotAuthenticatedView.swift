//
//  NotAuthenticatedView.swift
//  nbro
//
//  Created by Peter Gammelgaard Poulsen on 10/03/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class NotAuthenticatedView: UIView {
    
    let descriptionLabel = UILabel.descriptionLabel()
    let loginButton = UIButton.loginButton()
    let logoImageView = UIImageView.logoImageView()
    
    init() {
        super.init(frame: CGRect.zero)
        
        descriptionLabel.text = "NBRO is a club for passionate runners with a thing for sneakers and get-togethers. NBRO is without king, territory or rules. Everyone is welcome to join the 4+ weekly training sessions."
        loginButton.setTitle("Show upcoming events".uppercaseString, forState: .Normal)
        
        addSubview(descriptionLabel)
        addSubview(loginButton)
        addSubview(logoImageView)
        
        descriptionLabel.snp_makeConstraints { (make) -> Void in
            make.leading.trailing.equalTo(descriptionLabel.superview!).inset(10)
            make.top.equalTo(logoImageView.snp_bottom).offset(20)
        }
        loginButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(descriptionLabel.snp_bottom).offset(30)
            make.centerX.bottom.equalTo(loginButton.superview!)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        logoImageView.snp_makeConstraints { (make) in
            make.centerX.equalTo(logoImageView.superview!)
            make.top.equalTo(logoImageView.superview!).inset(10)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension UIImageView {
    static func logoImageView() -> UIImageView {
        return UIImageView(image: UIImage(named: "nbro_logo"))
    }
    
}

private extension UILabel {
    class func descriptionLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.defaultRegularFontOfSize(16)
        label.textColor = UIColor.whiteColor()
        label.numberOfLines = 0
        label.textAlignment = .Center
        
        return label
    }
}

private extension UIButton {
    class func loginButton() -> UIButton {
        let button = UIButton()
        button.setBackgroundImage(UIImage(color: UIColor(hex: 0xffffff, alpha: 0.1)), forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.defaultMediumFontOfSize(14)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.layer.cornerRadius = 6
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return button
    }
}