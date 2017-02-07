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
    let button: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(color: UIColor(hex: 0xffffff, alpha: 0.1)), for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.defaultMediumFontOfSize(14)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 6
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.setTitle("Pick an image".uppercased(), for: UIControlState())
        return button
    }()
    let container: UIView = UIView()
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultRegularFontOfSize(16)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Choose a image and decorate it with awesome NBRO stickers. You'll never run alone."
        return label
    }()
    let imageView: UIImageView = {
        return UIImageView(image: #imageLiteral(resourceName: "canvas_icon"))
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
        [ label, imageView, button ].forEach { container.addSubview($0) }
        [ container ].forEach { addSubview($0) }
    }
    
    fileprivate func defineLayout() {
        button.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(30)
            make.bottom.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)        }
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
        }
        
        container.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(50)
        }
    }
}
