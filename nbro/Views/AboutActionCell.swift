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
    let disclousureImageView = UIImageView.disclousureImageView()
    let iconImageView = UIImageView.iconImageView()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(hex: 0x101010)
        let highligtedView = UIView()
        highligtedView.backgroundColor = UIColor(hex: 0x2c2c2c)
        selectedBackgroundView = highligtedView
        
        let separatorColor = UIColor(hex: 0x2c2c2c)
        topSeparatorView.backgroundColor = separatorColor
        bottomSeparatorView.backgroundColor = separatorColor
        
        setupSubviews()
        defineLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(topSeparatorView)
        contentView.addSubview(bottomSeparatorView)
        contentView.addSubview(disclousureImageView)
        contentView.addSubview(iconImageView)
    }
    
    private func defineLayouts() {
        titleLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(titleLabel.superview!)
            make.left.equalTo(iconImageView.snp_right).offset(22)
        }
        
        topSeparatorView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(topSeparatorView.superview!)
            make.height.equalTo(1)
        }
        
        bottomSeparatorView.snp_makeConstraints { (make) in
            make.bottom.left.right.equalTo(bottomSeparatorView.superview!)
            make.height.equalTo(1)
        }
        
        disclousureImageView.snp_makeConstraints { (make) in
            make.centerY.equalTo(disclousureImageView.superview!)
            make.right.equalTo(-22)
        }
        
        iconImageView.snp_makeConstraints { (make) in
            make.centerY.equalTo(iconImageView.superview!)
            make.left.equalTo(22)
        }
    }
    
    func setTitleText(title: String) {
        let attrString = NSMutableAttributedString(string: title)
        attrString.addAttribute(NSKernAttributeName, value: 1.0, range: NSMakeRange(0, title.characters.count))
        titleLabel.attributedText = attrString
    }
    
    class func preferredCellHeight() -> CGFloat {
        return 55
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        let color = topSeparatorView.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if(selected) {
            topSeparatorView.backgroundColor = color
            bottomSeparatorView.backgroundColor = color
        }
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        let color = topSeparatorView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        
        if(highlighted) {
            topSeparatorView.backgroundColor = color
            bottomSeparatorView.backgroundColor = color
        }
    }
}


private extension UIImageView {
    static func disclousureImageView() -> UIImageView {
        return UIImageView(image: UIImage(named: "disclousure"))
    }
    
    static func iconImageView() -> UIImageView {
        return UIImageView()
    }
}

private extension UILabel {
    static func titleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .whiteColor()
        label.textAlignment = .Left
        label.font = UIFont.defaultMediumFontOfSize(13)
        return label
    }
}
