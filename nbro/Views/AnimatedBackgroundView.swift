//
//  AnimatedBackgroundView.swift
//  nbro
//
//  Created by Casper Storm Larsen on 13/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class AnimatedBackgroundView: UIView {
    let backgroundImageView = UIImageView.backgroundImageView()
    let vignetteImageView = UIImageView.vignetteImageView()
    let imageContainerView = UIView()
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .gray
        setupSubviews()
        defineLayout()

        setNeedsLayout()
        layoutIfNeeded()
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        addSubview(imageContainerView)
        imageContainerView.addSubview(backgroundImageView)
        imageContainerView.addSubview(vignetteImageView)
    }
    
    fileprivate func defineLayout() {
        imageContainerView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(imageContainerView.superview!)
        }
        
        vignetteImageView.snp_updateConstraints { (make) -> Void in
            make.edges.equalTo(vignetteImageView.superview!)
        }
    }
    
    override func updateConstraints() {
        self.backgroundImageView.snp_updateConstraints { (make) -> Void in
            make.centerY.equalTo(backgroundImageView.superview!)
            make.left.equalTo(backgroundImageView.superview!)
            
            let imageSize = backgroundImageView.image?.size ?? CGSize.zero
            let factor = backgroundImageView.superview!.frame.height / imageSize.height
            
            make.width.equalTo(imageSize.width * factor)
            make.height.equalTo(imageSize.height * factor)
        }
        super.updateConstraints()
    }
}

private extension UIImageView {
    static func backgroundImageView() -> UIImageView {
        let backgroundImageView = UIImageView(image: UIImage(named: "login_background_image_1"))
        return backgroundImageView
    }
    static func vignetteImageView() -> UIImageView {
        return UIImageView(image: UIImage(named: "background_vignette"))
    }
}
