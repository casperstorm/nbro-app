//
//  AboutView.swift
//  nbro
//
//  Created by Casper Storm Larsen on 15/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class AboutView: UIView {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        return tableView
    }()
//    
//    let informationTextView: UITextView = {
//        let textView = UITextView()
//        textView.textColor = .white
//        textView.backgroundColor = UIColor.orange
//
//        let headlineStyle = NSMutableParagraphStyle()
//        headlineStyle.alignment = .center
//    
//        let contentStyle = NSMutableParagraphStyle()
//        contentStyle.alignment = .justified
//        
//        let headlineAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.titleBoldFontOfSize(20), NSParagraphStyleAttributeName: headlineStyle]
//        let contentAttributes = [NSForegroundColorAttributeName: UIColor(hex:0xD1D1D1), NSFontAttributeName: UIFont.defaultRegularFontOfSize(14), NSParagraphStyleAttributeName: contentStyle]
//
//        
//        let heading = NSMutableAttributedString(string: "WE ARE NBRO RUNNERS OF COPENHAGEN.\nWE RUN THIS CITY.\n\n", attributes: headlineAttributes)
//        let content = NSMutableAttributedString(string: "NBRO is a running community for passionate runners with a thing for sneakers and social get-togethers.\n\nNBRO is without king, territory or rules. Everyone is welcome to join the 6+ weekly training events starting from Søpavillionen at the Lakes in the heart of Copenhagen. Our training is fun and varied for runners of all levels and comprises of cross, core and interval training as well as distances a mile too long.", attributes: contentAttributes)
//        
//        let combined = NSMutableAttributedString()
//        combined.append(heading)
//        combined.append(content)
//        
//        textView.attributedText = combined
//        textView.isEditable = false
//        textView.isScrollEnabled = true
//        textView.contentInset = UIEdgeInsetsMake(35, 0, 35, 0)
//        return textView
//    }()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .black
        setupSubviews()
        defineLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        let subviews = [tableView]
        subviews.forEach { addSubview($0) }
    }
    
    fileprivate func defineLayout() {        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}
