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
    let runnerLogoView = UIImageView.maskedRunnerImageView()
    let containerView = UIView()
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
        containerView.maskView = runnerLogoView
        containerView.backgroundColor = .whiteColor()
        contentView.addSubview(containerView)
    }
    
    private func defineLayouts() {
        runnerLogoView.snp_makeConstraints { (make) in
            make.centerX.equalTo(runnerLogoView.superview!)
            make.centerY.equalTo(runnerLogoView.superview!)
        }
        
        containerView.snp_makeConstraints { (make) in
            make.centerX.equalTo(containerView.superview!)
            make.centerY.equalTo(containerView.superview!).offset(25)
            make.height.width.equalTo(105)
        }
    }
    
    class func preferredCellHeight() -> CGFloat {
        return 150
    }
}

private extension UIImageView {
    static func maskedRunnerImageView() -> UIImageView {
        return UIImageView(image: UIImage(named: "runner_logo"))
    }
}