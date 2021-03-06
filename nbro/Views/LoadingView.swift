//
//  LoadingView.swift
//  nbro
//
//  Created by Casper Rogild Storm on 25/01/2018.
//  Copyright © 2018 Bob. All rights reserved.
//


import Foundation
import UIKit
import SnapKit

class LoadingView: UIView {
    let activityIndicatorView = UIActivityIndicatorView.activityIndicatorView()
    let statusLabel = UILabel.statusLabel()
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .clear
        setupSubviews()
        defineLayout()
        statusLabel.alpha = 0.0
        statusLabel.text = "Something went 🐴💩"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        let subviews = [activityIndicatorView, statusLabel]
        subviews.forEach { addSubview($0) }
    }
    
    fileprivate func defineLayout() {
        activityIndicatorView.snp.makeConstraints { (make) in
            make.edges.equalTo(activityIndicatorView.superview!)
        }
        
        statusLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(activityIndicatorView.superview!)
        }
    }
}

private extension UIActivityIndicatorView {
    static func activityIndicatorView() -> UIActivityIndicatorView {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = UIColor.white
        return activityIndicatorView
    }
}

private extension UILabel {
    static func statusLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.defaultRegularFontOfSize(13)
        return label
    }
}

