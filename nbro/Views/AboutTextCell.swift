//
//  AboutTextCell.swift
//  nbro
//
//  Created by Casper Storm Larsen on 15/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class AboutTextCell: UITableViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.titleBoldFontOfSize(18)
        label.numberOfLines = 0
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: 0x959595)
        label.textAlignment = .justified
        label.font = UIFont.defaultLightFontOfSize(15)
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        return label
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
        contentView.addSubview(contentLabel)
        contentView.addSubview(titleLabel)
    }
    
    fileprivate func defineLayouts() {
        contentLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(60)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(60)
            make.top.equalToSuperview().offset(15)
        }
    }
}
