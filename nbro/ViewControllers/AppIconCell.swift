//
//  AppIconCell.swift
//  nbro
//
//  Created by Casper Rogild Storm on 26/01/2018.
//  Copyright © 2018 Bob. All rights reserved.
//

import Foundation
import UIKit

class AppIconCell: UITableViewCell {
    let titleLabel = UILabel.titleLabel()
    let containerView = UIView()
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
    
    fileprivate func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(topSeparatorView)
        contentView.addSubview(bottomSeparatorView)
        contentView.addSubview(disclousureImageView)
        contentView.addSubview(iconImageView)
    }
    
    fileprivate func defineLayouts() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(22)
            make.centerY.equalTo(titleLabel.superview!)
        }

        topSeparatorView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(topSeparatorView.superview!)
            make.height.equalTo(1)
        }
        
        bottomSeparatorView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(bottomSeparatorView.superview!)
            make.height.equalTo(1)
        }
        
        disclousureImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(disclousureImageView.superview!)
            make.right.equalTo(-22)
            make.width.height.lessThanOrEqualTo(18)
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(iconImageView.superview!).inset(15)
            make.left.equalTo(22)
            make.width.height.lessThanOrEqualTo(40).priority(10)
        }
    }
    
    func setTitleText(_ title: String) {
        let attrString = NSMutableAttributedString(string: title)
        attrString.addAttribute(NSAttributedStringKey.kern, value: 1.0, range: NSMakeRange(0, title.count))
        titleLabel.attributedText = attrString
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = topSeparatorView.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if(selected) {
            topSeparatorView.backgroundColor = color
            bottomSeparatorView.backgroundColor = color
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
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
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "checkmark")
        return imageView
    }
    
    static func iconImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 9
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}

private extension UILabel {
    static func titleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.defaultMediumFontOfSize(14)
        return label
    }
}
