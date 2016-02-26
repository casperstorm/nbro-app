//
//  AttendEventButtonView.swift
//  nbro
//
//  Created by Casper Storm Larsen on 26/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class AttentEventButtonView: UIView {
    let button = UIButton.button()
    let activityIndicatorView = UIActivityIndicatorView.activityIndicatorView()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .grayColor()
        setupSubviews()
        defineLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(button)
        addSubview(activityIndicatorView)
    }
    
    private func defineLayout() {
        button.snp_makeConstraints { (make) in
            make.edges.equalTo(button.superview!)
            make.height.equalTo(55)
        }
        
        activityIndicatorView.snp_makeConstraints { (make) in
            make.center.equalTo(activityIndicatorView.superview!)
        }
    }
    
    func startAnimating() {
        activityIndicatorView.startAnimating()
        button.hidden = true
    }
    
    func stopAnimating() {
        activityIndicatorView.stopAnimating()
        button.hidden = false
    }
}

private extension UIButton {
    static func button() -> UIButton {
        let button = UIButton()
        let font = UIFont.defaultRegularFontOfSize(15)
        button.titleLabel?.font = font
        button.backgroundColor = UIColor.grayColor()
        button.setTitleColor(.whiteColor(), forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        return button
    }
}

private extension UIActivityIndicatorView {
    static func activityIndicatorView() -> UIActivityIndicatorView {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = UIColor.blackColor()
        return activityIndicatorView
    }
}