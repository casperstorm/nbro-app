//
//  UserEventCell.swift
//  nbro
//
//  Created by Casper Storm Larsen on 23/03/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class UserEventCell: UITableViewCell {
    let titleLabel = UILabel.titleLabel()
    let detailLabel = UILabel.detailLabel()
    let topSeparatorView = UIView()
    let bottomSeparatorView = UIView()
    let disclousureImageView = UIImageView.disclousureImageView()
    let iconImageView = UIImageView.iconImageView()
    let textContainer = UIView()
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
        contentView.addSubview(textContainer)
        textContainer.addSubview(detailLabel)
        textContainer.addSubview(titleLabel)
        contentView.addSubview(topSeparatorView)
        contentView.addSubview(bottomSeparatorView)
        contentView.addSubview(disclousureImageView)
        contentView.addSubview(iconImageView)
    }
    
    fileprivate func defineLayouts() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.superview!)
            make.left.right.equalTo(titleLabel.superview!)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(detailLabel.superview!)
            make.left.right.equalTo(detailLabel.superview!)
        }
        
        textContainer.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(22)
            make.right.equalTo(disclousureImageView.snp.left).offset(-22)
            make.top.bottom.equalTo(textContainer.superview!).inset(15)
        }
        
        topSeparatorView.snp.makeConstraints { (make) in
            make.left.right.equalTo(topSeparatorView.superview!)
            make.top.equalTo(topSeparatorView.superview!).offset(-1)
            make.height.equalTo(1)
        }
        
        bottomSeparatorView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(bottomSeparatorView.superview!)
            make.height.equalTo(1)
        }
        
        disclousureImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(disclousureImageView.superview!)
            make.right.equalTo(-22)
            make.width.equalTo(6)
            make.height.equalTo(11)
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconImageView.superview!)
            make.left.equalTo(22)
            make.width.equalTo(19)
            make.height.equalTo(17)
        }
        
    }
    
    func setTitleText(_ title: String) {
        let attrString = NSMutableAttributedString(string: title)
        attrString.addAttribute(NSKernAttributeName, value: 1.0, range: NSMakeRange(0, title.characters.count))
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
        return UIImageView(image: UIImage(named: "disclousure"))
    }
    
    static func iconImageView() -> UIImageView {
        return UIImageView()
    }
}

private extension UILabel {
    static func titleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.defaultMediumFontOfSize(13)
        return label
    }
    static func detailLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor(hex: 0xffffff, alpha: 0.5)
        label.textAlignment = .left
        label.font = UIFont.defaultMediumFontOfSize(13)
        return label
    }
}
