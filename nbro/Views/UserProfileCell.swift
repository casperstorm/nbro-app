//
//  UserProfileCell.swift
//  nbro
//
//  Created by Casper Storm Larsen on 23/03/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class UserProfileCell: UITableViewCell {
    let userImageView = UIImageView()
    let userNameLabel = UILabel.userNameLabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clearColor()
        selectionStyle = .None;
        
        setupSubviews()
        defineLayouts()
        
        userImageView.layer.cornerRadius = 45
        userImageView.clipsToBounds = true
        userImageView.contentMode = .ScaleAspectFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
    }
    
    private func defineLayouts() {
        userImageView.snp_makeConstraints { (make) in
            make.top.equalTo(userImageView.superview!).inset(40)
            make.centerX.equalTo(userImageView.superview!)
            make.width.height.equalTo(90).priorityHigh()
        }
        
        userNameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(userImageView.snp_bottom).offset(30)
            make.leading.trailing.equalTo(userNameLabel.superview!).inset(20)
            make.height.equalTo(30)
            make.bottom.equalTo(userNameLabel.superview!)
        }
    }
}

private extension UILabel {
    static func userNameLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.font = UIFont.titleBoldFontOfSize(25)
        return label
    }
}