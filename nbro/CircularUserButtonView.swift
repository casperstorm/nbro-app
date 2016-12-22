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
        backgroundColor = .clear
        setupSubviews()
        defineLayout()
        
        imageView.layer.cornerRadius = 30
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        addSubview(imageView)
        addSubview(button)
    }
    
    fileprivate func defineLayout() {
        imageView.snp_makeConstraints { (make) in
            make.edges.equalTo(imageView.superview!)
        }
        
        button.snp_makeConstraints { (make) in
            make.edges.equalTo(button.superview!)
        }
    }
}
