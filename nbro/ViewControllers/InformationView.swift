//
//  NotAuthenticatedView.swift
//  nbro
//
//  Created by Peter Gammelgaard Poulsen on 10/03/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class InformationView: UIView {
    fileprivate let titleBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xE0E100, alpha: 0.55)
        return view
    }()
    
    let button = UIButton()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.titleBoldFontOfSize(44)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultRegularFontOfSize(14)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        return label
    }()
    
    init() {
        super.init(frame: CGRect.zero)

        setupSubviews()
        defineLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InformationView {
    fileprivate func setupSubviews() {
        [titleBackgroundView, titleLabel, descriptionLabel, button].forEach({ addSubview($0) })
    }
    
    fileprivate func defineLayout() {
        titleBackgroundView.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.width.equalTo(244)
            
            make.left.top.right.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleBackgroundView)
            make.centerY.equalTo(titleBackgroundView).offset(4)

        }
        
        button.snp.makeConstraints { (make) in
            make.edges.equalTo(titleBackgroundView)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleBackgroundView)
            make.top.equalTo(titleBackgroundView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    
    }
}

