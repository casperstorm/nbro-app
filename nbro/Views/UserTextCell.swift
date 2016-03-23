//
//  UserTextCell.swift
//  nbro
//
//  Created by Casper Storm Larsen on 23/03/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class UserTextCell: UITableViewCell {
    let bodyLabel = UILabel.bodyLabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clearColor()
        selectionStyle = .None;
        
        setupSubviews()
        defineLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(bodyLabel)
        
    }
    
    private func defineLayouts() {
        bodyLabel.snp_makeConstraints { (make) in
            make.width.equalTo(bodyLabel.superview!).inset(40)
            make.centerX.equalTo(bodyLabel.superview!)
            make.top.equalTo(bodyLabel.superview!).offset(16)
            make.bottom.equalTo(bodyLabel.superview!).inset(25)
        }
    }
}

private extension UILabel {
    static func bodyLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor(hex: 0x959595)
        label.textAlignment = .Center
        label.font = UIFont.defaultLightFontOfSize(15)
        label.numberOfLines = 0
        return label
    }
}