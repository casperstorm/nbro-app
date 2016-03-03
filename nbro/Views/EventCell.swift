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
        
        nameTextView.textContainerInset = UIEdgeInsets(top: 24, left: 7, bottom: 25, right: 10)
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
            make.left.bottom.right.equalTo(dateLabel.superview!).inset(EdgeInsets(top: 0, left: 35, bottom: 20, right: 22))
            make.top.equalTo(nameTextView.snp_bottom).offset(-25)
        }
    }
    
    func nameLabelText(name: String) {
        let attrString = NSMutableAttributedString(string: name)
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 0.7
        attrString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length:
                                                                                name.characters.count))
        attrString.addAttribute(NSFontAttributeName, value: UIFont.titleBoldFontOfSize(42), range: NSRange(location: 0, length:
                                                                                name.characters.count))
        attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location: 0, length:
            name.characters.count))

        nameTextView.attributedText = attrString
        nameTextView.setNeedsDisplay()
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseOut, animations: { 
            self.nameTextView.alpha = highlighted ? 0.6 : 1.0
            }) { (_) in
        }
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
        label.userInteractionEnabled = false
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

    override func drawRect(rect: CGRect) {
        var rects = [CGRect]()
        
        self.layoutManager.enumerateLineFragmentsForGlyphRange(NSMakeRange(0, self.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))) { (rect, usedRect, textContainer, glyphRange, stop) -> Void in
            if rects.count < 2 { // Only support 2 lines
                rects.append(usedRect)
            }
        }
        
        let inset = UIEdgeInsets(top: 0, left: 20, bottom: 21, right: 3)

        if rects.count == 1 {
            let usedRect = rects.first!
            
            let path = UIBezierPath(rect: CGRect(x: usedRect.origin.x - inset.left, y: 0, width: usedRect.size.width + inset.left + inset.right + self.textContainerInset.left + self.textContainerInset.right, height: usedRect.size.height + inset.top + inset.bottom))
            UIColor(hex: 0x76edff, alpha: 0.55).setFill()
            path.fill()
        } else if rects.count == 2 {
            var topRect = rects.first!
            var bottomRect = rects.last!
            
            if -10...10 ~= topRect.width - bottomRect.width { // if almost same width, make them the same width
                let maxWidth = max(topRect.width, bottomRect.width)
                topRect.size.width = maxWidth
                bottomRect.size.width = maxWidth
            }
            
            if topRect.width > bottomRect.width {
                let path = UIBezierPath(rect: CGRect(x: topRect.origin.x - inset.left, y: 0, width: topRect.size.width + inset.left + inset.right + self.textContainerInset.left + self.textContainerInset.right, height: CGFloat(Int(topRect.size.height + inset.top + inset.bottom))))
                UIColor(hex: 0x76edff, alpha: 0.55).setFill()
                path.fill()
                
                let lastPath = UIBezierPath(rect: CGRect(x: bottomRect.origin.x - inset.left, y: CGFloat(Int(bottomRect.origin.y + inset.bottom)), width: bottomRect.size.width + inset.left + inset.right + self.textContainerInset.left + self.textContainerInset.right, height: bottomRect.size.height + inset.top))
                UIColor(hex: 0x76edff, alpha: 0.55).setFill()
                lastPath.fill()
            } else {
                let path = UIBezierPath(rect: CGRect(x: topRect.origin.x - inset.left, y: 0, width: topRect.size.width + inset.left + inset.right + self.textContainerInset.left + self.textContainerInset.right, height: CGFloat(Int(topRect.size.height + inset.top))))
                UIColor(hex: 0x76edff, alpha: 0.55).setFill()
                path.fill()
                
                let lastPath = UIBezierPath(rect: CGRect(x: bottomRect.origin.x - inset.left, y: CGFloat(Int(bottomRect.origin.y)), width: bottomRect.size.width + inset.left + inset.right + self.textContainerInset.left + self.textContainerInset.right, height: CGFloat(Int(bottomRect.size.height + inset.top + inset.bottom))))
                UIColor(hex: 0x76edff, alpha: 0.55).setFill()
                lastPath.fill()
            }
            
        }
    }
}