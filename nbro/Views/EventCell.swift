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
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.titleBoldFontOfSize(42)
        label.textColor = UIColor.whiteColor()
        label.numberOfLines = 0
        label.lineBreakMode = .ByCharWrapping
        let string = "LONG SATURDAY (ALL MOODS)"
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location: 0, length: string.characters.count))
        label.attributedText = attrString
    
        //[mutableAttributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:selectedRange];

        /*
         let attrString = NSMutableAttributedString(string: combinedString.uppercaseString)
         attrString.addAttribute(NSFontAttributeName, value: authFont, range: authRange)
         attrString.addAttribute(NSFontAttributeName, value: fbFont, range: fbRange)
         attrString.addAttribute(NSKernAttributeName, value: 1.1, range: fbRange)
         attrString.addAttribute(NSKernAttributeName, value: 1.1, range: authRange)
         
         facebookButton.setAttributedTitle(attrString, forState: .Normal)
        */
        
        return label
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFontOfSize(14)
        label.textColor = UIColor.whiteColor()
        return label
    }()
    
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
            make.left.top.right.equalTo(nameLabel.superview!).inset(22)
            make.bottom.equalTo(dateLabel.snp_top)
        }
        
        dateLabel.snp_makeConstraints { (make) in
            make.left.bottom.right.equalTo(dateLabel.superview!).inset(22)
            make.top.equalTo(nameLabel.snp_bottom)
        }
    }
}
