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
        
        backgroundColor = UIColor.blackColor()
        selectionStyle = .None;
        
        setupSubviews()
        defineLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let subviews = [nameLabel, versionLabel]
        subviews.forEach { addSubview($0) }
    }
    
    private func defineLayouts() {
        nameLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(nameLabel.superview!)
            make.bottom.equalTo(versionLabel.snp_top)
        }
        
        versionLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(versionLabel.superview!)
            make.bottom.equalTo(versionLabel.superview!).offset(-16)
        }
    }
    
    class func preferredCellHeight() -> CGFloat {
        return 75
    }
}


private extension UILabel {
    static func nameLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .whiteColor()
        label.textAlignment = .Center
        label.font = UIFont.defaultSemiBoldFontOfSize(14)
        return label
    }
    
    static func versionLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .grayColor()
        label.textAlignment = .Center
        label.font = UIFont.defaultFontOfSize(14)
        return label
    }
}
