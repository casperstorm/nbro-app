//
//  CircularUserButtonView.swift
//  nbro
//
//  Created by Casper Storm Larsen on 22/03/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class CircularUserButtonView: UIView {
    let imageView = UIImageView()
    let button = UIButton()
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .clearColor()
        setupSubviews()
        defineLayout()
        
        imageView.layer.cornerRadius = 30
        imageView.backgroundColor = .clearColor()
        imageView.clipsToBounds = true
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSizeMake(0, 1)
        layer.shadowRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(imageView)
        addSubview(button)
    }
    
    private func defineLayout() {
        imageView.snp_makeConstraints { (make) in
            make.edges.equalTo(imageView.superview!)
        }
        
        button.snp_makeConstraints { (make) in
            make.edges.equalTo(button.superview!)
        }
    }
}
