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
    let runnerLogoView = UIImageView.runnerImageView()
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
        contentView.addSubview(runnerLogoView)
    }
    
    fileprivate func defineLayouts() {
        runnerLogoView.snp.makeConstraints { (make) in
            make.top.equalTo(runnerLogoView.superview!).inset(30)
            make.bottom.equalTo(runnerLogoView.superview!).inset(10)
            make.centerX.equalTo(runnerLogoView.superview!)
        }
    }

}

private extension UIImageView {
    static func runnerImageView() -> UIImageView {
        return UIImageView(image: UIImage(named: "nbro_logo"))
    }
}
