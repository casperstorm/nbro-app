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
    let switchView = SwitchView()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .whiteColor()
        setupSubviews()
        defineLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(switchView)
    }
    
    private func defineLayout() {
        switchView.snp_makeConstraints { (make) in
            make.edges.equalTo(switchView.superview!)
            make.height.equalTo(44)
        }
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let convertedPoint = self.convertPoint(point, toView: switchView)
        return switchView.hitTest(convertedPoint, withEvent: event)
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