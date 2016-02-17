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
    private static let DateLabelHeight: CGFloat = 15
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
            make.height.equalTo(EventCell.DateLabelHeight)
        }
    }
    
    class func calculatedHeightForCellWithText(string: String?) -> CGFloat {
        if string == nil {
            return 0
        }
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let maxWidth = CGRectGetWidth(screenSize) - (EventCell.DefaultMargin * 2)
        let stringHeight = string?.heightWithConstrainedWidth(maxWidth, font: UIFont.titleBoldFontOfSize(42))
        let height = stringHeight! + DefaultMargin + DefaultMargin + DateLabelHeight
        return height
    }
}


private extension UILabel {
    static func nameLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.titleBoldFontOfSize(42)
        label.textColor = UIColor.whiteColor()
        label.numberOfLines = 0
                label.lineBreakMode = .ByCharWrapping
                let string = "LONG SATURDAY (ALL MOODS)"
                let attrString = NSMutableAttributedString(string: string)
                attrString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location: 0, length: string.characters.count))
                label.attributedText = attrString
        return label
    }
    static func dateLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.defaultMediumFontOfSize(14)
        label.textColor = UIColor.whiteColor()
        return label
    }
}