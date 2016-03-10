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
        
        backgroundColor = .blackColor()
        selectionStyle = .None;
        
        setupSubviews()
        defineLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(runnerLogoView)
    }
    
    private func defineLayouts() {
        runnerLogoView.snp_makeConstraints { (make) in
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