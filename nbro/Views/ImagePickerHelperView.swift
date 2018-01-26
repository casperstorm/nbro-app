//
//  ImagePickerHelperView.swift
//  nbro
//
//  Created by Casper Rogild Storm on 26/01/2018.
//  Copyright © 2018 Bob. All rights reserved.
//

import Foundation
import UIKit

class ImagePickerHelperView: UIView {
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultRegularFontOfSize(14)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let gradient: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "about_gradient_shadow"))
        return image
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .clear
        
        setupSubviews()
        defineLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImagePickerHelperView {
    fileprivate func setupSubviews() {
        [gradient, container, textLabel].forEach({ addSubview($0) })
    }
    
    fileprivate func defineLayout() {
        container.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(container.superview!)
            make.top.equalTo(gradient.snp.bottom)
        }
        
        textLabel.snp.makeConstraints { (make) in
            make.center.equalTo(container).inset(UIEdgeInsetsMake(-10, 0, 0, 0 ))
        }
        
        gradient.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(gradient.superview!)
        }
        
    }
}
