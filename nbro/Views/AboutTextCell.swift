//
//  AboutTextCell.swift
//  nbro
//
//  Created by Casper Storm Larsen on 15/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class AboutTextCell: UITableViewCell {
    let headerLabel = UILabel.headerLabel()
    let bodyLabel = UILabel.bodyLabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .blackColor()
        selectionStyle = .None;
        
        setupSubviews()
        defineLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(headerLabel)
        contentView.addSubview(bodyLabel)
        
    }
    
    private func defineLayouts() {
        headerLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(headerLabel.superview!)
            make.top.equalTo(16)
        }
        
        bodyLabel.snp_makeConstraints { (make) in
            make.width.equalTo(bodyLabel.superview!).inset(40)
            make.centerX.equalTo(bodyLabel.superview!)
            make.top.equalTo(headerLabel.snp_bottom).offset(16)
        }
    }
    
    class func preferredCellHeight() -> CGFloat {
        return 200
    }
}

private extension UILabel {
    static func headerLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .whiteColor()
        label.textAlignment = .Center
        label.font = UIFont.titleBoldFontOfSize(32)
        return label
    }
    static func bodyLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor(hex: 0x959595)
        label.textAlignment = .Center
        label.font = UIFont.defaultLightFontOfSize(15)
        label.numberOfLines = 0
        return label
    }
}
