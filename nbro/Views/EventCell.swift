//
//  EventCell.swift
//  nbro
//
//  Created by Casper Storm Larsen on 13/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class EventCell: UITableViewCell {
    let nameLabel = UILabel.nameLabel()
    let dateLabel = UILabel.dateLabel()
    private static let DefaultMargin: CGFloat = 22
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None;

        setupSubviews()
        defineLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
    }
    
    func defineLayouts() {
        
        nameLabel.snp_makeConstraints { (make) in
            make.left.top.right.equalTo(nameLabel.superview!).inset(EventCell.DefaultMargin)
            make.bottom.equalTo(dateLabel.snp_top)
        }
        
        dateLabel.snp_makeConstraints { (make) in
            make.left.bottom.right.equalTo(dateLabel.superview!).inset(EventCell.DefaultMargin)
            make.top.equalTo(nameLabel.snp_bottom)
        }
    }
    
    func nameLabelText(name: String) {
        nameLabel.text = name
//        nameLabel.textAlignment = .Justified
//
//        let attrString = NSMutableAttributedString(string: name)
//        attrString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.blackColor(),
//                                                                range: NSRange(location: 0, length:
//                                                                    name.characters.count))
//        nameLabel.attributedText = attrString
    }
}

private extension UILabel {
    static func nameLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.titleBoldFontOfSize(42)
        label.textColor = UIColor.whiteColor()
        label.numberOfLines = 0

        return label
    }
    static func dateLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.defaultMediumFontOfSize(14)
        label.textColor = UIColor.whiteColor()
        return label
    }
}