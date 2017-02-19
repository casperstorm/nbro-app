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
        
        backgroundColor = .clear
        selectionStyle = .none;
        
        setupSubviews()
        defineLayouts()
        
        userImageView.layer.cornerRadius = 45
        userImageView.clipsToBounds = true
        userImageView.contentMode = .scaleAspectFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
    }
    
    fileprivate func defineLayouts() {
        userImageView.snp.makeConstraints { (make) in
            make.top.equalTo(userImageView.superview!).inset(40)
            make.centerX.equalTo(userImageView.superview!)
            make.width.height.equalTo(90).priority(750)
        }
        
        userNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userImageView.snp.bottom).offset(30)
            make.leading.trailing.equalTo(userNameLabel.superview!).inset(20)
            make.height.equalTo(30)
            make.bottom.equalTo(userNameLabel.superview!)
        }
    }
}

private extension UILabel {
    static func userNameLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.titleBoldFontOfSize(25)
        return label
    }
}
