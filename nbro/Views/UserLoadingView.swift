//
//  UserLoadingView.swift
//  nbro
//
//  Created by Casper Storm Larsen on 25/03/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class UserLoadingView: UIView {
    let activityIndicatorView = UIActivityIndicatorView.activityIndicatorView()
    let statusLabel = UILabel.statusLabel()
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .clearColor()
        setupSubviews()
        defineLayout()
        
        activityIndicatorView.startAnimating()
        statusLabel.alpha = 0.0
        statusLabel.text = "Something went 🐴💩"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let subviews = [activityIndicatorView, statusLabel]
        subviews.forEach { addSubview($0) }
    }
    
    private func defineLayout() {
        activityIndicatorView.snp_makeConstraints { (make) in
            make.edges.equalTo(activityIndicatorView.superview!)
        }
        
        statusLabel.snp_makeConstraints { (make) in
            make.edges.equalTo(activityIndicatorView.superview!)
        }
    }
}

private extension UIActivityIndicatorView {
    static func activityIndicatorView() -> UIActivityIndicatorView {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = UIColor.whiteColor()
        return activityIndicatorView
    }
}

private extension UILabel {
    static func statusLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .whiteColor()
        label.textAlignment = .Center
        label.font = UIFont.defaultRegularFontOfSize(13)
        return label
    }
}