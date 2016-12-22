//
//  LogoCell.swift
//  nbro
//
//  Created by Casper Storm Larsen on 13/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class LogoCell: UITableViewCell {
    let logoImageView = UIImageView.logoImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none;
        
        setupSubviews()
        defineLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        contentView.addSubview(logoImageView)
    }
    
    func defineLayouts() {
        logoImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(logoImageView.superview!)
            make.bottom.equalTo(logoImageView.superview!).inset(16)
            make.top.equalTo(logoImageView.superview!).inset(40)
        }
    }
}

private extension UIImageView {
    static func logoImageView() -> UIImageView {
        return UIImageView(image: UIImage(named: "nbro_logo"))
    }
    
}
