//
//  MaskedLogoCell.swift
//  nbro
//
//  Created by Casper Storm Larsen on 15/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class AboutLogoCell: UITableViewCell {
    let logoImageView: UIImageView = {
       return UIImageView()
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .black
        selectionStyle = .none;
        
        setupSubviews()
        defineLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        contentView.addSubview(logoImageView)
    }
    
    fileprivate func defineLayouts() {
        logoImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
    }

}
