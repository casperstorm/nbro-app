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
        backgroundColor = .clear
        setupSubviews()
        defineLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func defineLayout() {
        containerView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(containerView.superview!)
        }
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.left.top.right.equalTo(titleLabel.superview!)
        }
        
        detailLabel.snp.makeConstraints { (make) -> Void in
            make.left.bottom.right.equalTo(detailLabel.superview!)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
        }
    }
    
    fileprivate func setupSubviews() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(detailLabel)
    }
}

private extension UILabel {
    static func titleLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.defaultSemiBoldFontOfSize(14)
        label.textColor = UIColor(red: 115/255.0, green: 115/255.0, blue: 115/255.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }
    static func detailLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.titleBoldFontOfSize(38)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }
}

