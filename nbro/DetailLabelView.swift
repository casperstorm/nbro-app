//
//  DetailLabelView.swift
//  nbro
//
//  Created by Casper Storm Larsen on 17/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class DetailLabelView: UIView {
    let titleLabel = UILabel.titleLabel()
    let detailLabel = UILabel.detailLabel()
    let containerView = UIView()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .clearColor()
        setupSubviews()
        defineLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func defineLayout() {
        containerView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(containerView.superview!)
        }
        
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.left.top.right.equalTo(titleLabel.superview!)
        }
        
        detailLabel.snp_makeConstraints { (make) -> Void in
            make.left.bottom.right.equalTo(detailLabel.superview!)
            make.top.equalTo(titleLabel.snp_bottom).offset(10)
        }
    }
    
    private func setupSubviews() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(detailLabel)
    }
}

private extension UILabel {
    static func titleLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.defaultRegularFontOfSize(12)
        label.textColor = UIColor(hex: 0x737373)
        label.textAlignment = .Center
        return label
    }
    static func detailLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.titleBoldFontOfSize(22)
        label.textColor = .blackColor()
        label.textAlignment = .Center
        return label
    }
}

