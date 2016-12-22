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
//    let button = UIButton.button()
    let switchView = SwitchView()
    let activityIndicatorView = UIActivityIndicatorView.activityIndicatorView()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .white
        setupSubviews()
        defineLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        addSubview(switchView)
        addSubview(activityIndicatorView)
    }
    
    fileprivate func defineLayout() {
        switchView.snp.makeConstraints { (make) in
            make.edges.equalTo(switchView.superview!)
            make.height.equalTo(44)
        }
        
        activityIndicatorView.snp.makeConstraints { (make) in
            make.center.equalTo(activityIndicatorView.superview!)
        }
    }
    
    func startAnimating() {
        activityIndicatorView.startAnimating()
        switchView.isHidden = true
    }
    
    func stopAnimating() {
        activityIndicatorView.stopAnimating()
        switchView.isHidden = false
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let convertedPoint = self.convert(point, to: switchView)
        return switchView.hitTest(convertedPoint, with: event)
    }
    
}

private extension UIButton {
    static func button() -> UIButton {
        let button = UIButton()
        let font = UIFont.defaultRegularFontOfSize(15)
        button.titleLabel?.font = font
        button.backgroundColor = UIColor.gray
        button.setTitleColor(.white, for: UIControlState())
        button.setTitleColor(UIColor.black, for: UIControlState())
        return button
    }
}

private extension UIActivityIndicatorView {
    static func activityIndicatorView() -> UIActivityIndicatorView {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = UIColor.black
        return activityIndicatorView
    }
}
