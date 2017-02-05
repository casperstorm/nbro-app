//
//  ImagePickerView.swift
//  nbro
//
//  Created by Casper Storm Larsen on 05/02/2017.
//  Copyright © 2017 Bob. All rights reserved.
//

import Foundation
import UIKit

class ImagePickerView: UIView {
    let button: UIButton = UIButton()
    let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: 0xffffff)
        label.textAlignment = .center
        label.font = .defaultBoldFontOfSize(22)
        label.text = "PRESS TO\nADD IMAGE"
        label.numberOfLines = 2
        return label
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        setupSubviews()
        defineLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        backgroundColor = UIColor(hex:0x000000)
        [ label, button ].forEach { addSubview($0) }
    }
    
    fileprivate func defineLayout() {
        button.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
    }
}
