//
//  ImagePickerHelperView.swift
//  nbro
//
//  Created by Casper Rogild Storm on 26/01/2018.
//  Copyright © 2018 Bob. All rights reserved.
//

import Foundation
import UIKit

class ImagePickerHelperView: UIView {
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultRegularFontOfSize(14)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .black
        
        setupSubviews()
        defineLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImagePickerHelperView {
    fileprivate func setupSubviews() {
        [textLabel].forEach({ addSubview($0) })
    }
    
    fileprivate func defineLayout() {
        textLabel.snp.makeConstraints { (make) in
            make.center.equalTo(textLabel.superview!).inset(UIEdgeInsetsMake(0, 0, 0, 0 ))
        }
    }
}
