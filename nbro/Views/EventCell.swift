//
//  EventCell.swift
//  nbro
//
//  Created by Casper Storm Larsen on 13/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class EventCell: UITableViewCell {
    let nameTextView = TextView.nameTextView()
    let dateLabel = UILabel.dateLabel()
    private static let DefaultMargin: CGFloat = 22
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None;

        setupSubviews()
        defineLayouts()
        
        nameTextView.textContainerInset = UIEdgeInsets(top: 8, left: 7, bottom: 10, right: 10)
        nameTextView.font = UIFont.titleBoldFontOfSize(42)
        nameTextView.textColor = UIColor.whiteColor()
        nameTextView.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        contentView.addSubview(nameTextView)
        contentView.addSubview(dateLabel)
    }
    
    func defineLayouts() {
        
        nameTextView.snp_makeConstraints { (make) in
            make.left.top.right.equalTo(nameTextView.superview!).inset(EventCell.DefaultMargin)
        }
        
        dateLabel.snp_makeConstraints { (make) in
            make.left.bottom.right.equalTo(dateLabel.superview!).inset(EdgeInsets(top: 0, left: 35, bottom: 15, right: 22))
            make.top.equalTo(nameTextView.snp_bottom).offset(-10)
        }
    }
    
    func nameLabelText(name: String) {
        nameTextView.text = name
        nameTextView.setNeedsDisplay()
    }
}

private extension UILabel {
    static func dateLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.defaultMediumFontOfSize(14)
        label.textColor = UIColor.whiteColor()
        return label
    }
}

class TextView: UITextView, NSLayoutManagerDelegate {
    static func nameTextView() -> TextView {
        let label = TextView()
        label.editable = false
        label.scrollEnabled = false
        label.textContainer.maximumNumberOfLines = 2;
        label.font = UIFont.titleBoldFontOfSize(42)
        label.textColor = UIColor.whiteColor()
        
        return label
    }
    
    init() {
        super.init(frame: CGRect.zero, textContainer: nil)
        self.layoutManager.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func layoutManager(layoutManager: NSLayoutManager, lineSpacingAfterGlyphAtIndex glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 5
    }
    
    override func drawRect(rect: CGRect) {
        self.layoutManager.enumerateLineFragmentsForGlyphRange(NSMakeRange(0, self.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))) { (rect, usedRect, textContainer, glyphRange, stop) -> Void in
            let inset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 5)
            let path = UIBezierPath(rect: CGRect(x: usedRect.origin.x - inset.left, y: usedRect.origin.y - inset.top, width: usedRect.size.width + inset.left + inset.right + self.textContainerInset.left + self.textContainerInset.right, height: usedRect.size.height + inset.top + inset.bottom))
            UIColor(hex: 0x76edff, alpha: 0.55).setFill()
            path.fill()
        }
    }
}