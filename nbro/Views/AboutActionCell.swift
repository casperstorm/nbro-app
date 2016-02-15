//
//  AboutActionCell.swift
//  nbro
//
//  Created by Casper Storm Larsen on 15/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class AboutActionCell: UITableViewCell {
    let titleLabel = UILabel.titleLabel()
    let topSeparatorView = UIView()
    let bottomSeparatorView = UIView()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(hex: 0x171717)
        topSeparatorView.backgroundColor = UIColor(hex: 0x2c2c2c)
        bottomSeparatorView.backgroundColor = UIColor(hex: 0x2c2c2c)

        setupSubviews()
        defineLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(topSeparatorView)
        contentView.addSubview(bottomSeparatorView)
    }
    
    func defineLayouts() {
        titleLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(titleLabel.superview!)
            make.left.equalTo(22)
        }
        
        topSeparatorView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(topSeparatorView.superview!)
            make.height.equalTo(1)
        }
        
        bottomSeparatorView.snp_makeConstraints { (make) in
            make.bottom.left.right.equalTo(bottomSeparatorView.superview!)
            make.height.equalTo(1)
        }
    }
    
    class func preferredCellHeight() -> CGFloat {
        return 47
    }
}

private extension UILabel {
    static func titleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .whiteColor()
        label.textAlignment = .Left
        label.font = UIFont.defaultFontOfSize(13)
        return label
    }
}
