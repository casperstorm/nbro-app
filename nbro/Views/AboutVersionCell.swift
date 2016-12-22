//
//  VersionCell.swift
//  nbro
//
//  Created by Casper Storm Larsen on 15/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class AboutVersionCell: UITableViewCell {
    let nameLabel = UILabel.nameLabel()
    let versionLabel = UILabel.versionLabel()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.black
        selectionStyle = .none;
        
        setupSubviews()
        defineLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        let subviews = [nameLabel, versionLabel]
        subviews.forEach { addSubview($0) }
    }
    
    fileprivate func defineLayouts() {
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.superview!).inset(16)
            make.centerX.equalTo(nameLabel.superview!)
            make.bottom.equalTo(versionLabel.snp.top)
        }
        
        versionLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(versionLabel.superview!)
            make.bottom.equalTo(versionLabel.superview!).offset(-16)
        }
    }
}


private extension UILabel {
    static func nameLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.defaultSemiBoldFontOfSize(14)
        return label
    }
    
    static func versionLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.defaultLightFontOfSize(14)
        return label
    }
}
