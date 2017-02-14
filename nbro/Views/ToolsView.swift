//
//  ToolsView.swift
//  nbro
//
//  Created by Casper Storm Larsen on 14/02/2017.
//  Copyright © 2017 Bob. All rights reserved.
//

import Foundation
import UIKit

class ToolsView: UIView {
    enum State {
        case sticker, dragging, delete, loading
    }
    
    let container = UIView()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.defaultLightFontOfSize(15)
        return label
    }()
    let button: UIButton = {
       return UIButton()
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        activity.color = .white
        return activity
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

extension ToolsView {
    fileprivate func setupSubviews() {
        addSubview(container)
        addSubview(button)
        container.addSubview(titleLabel)
        container.addSubview(imageView)
        container.addSubview(activityIndicatorView)
        
        changeState(.sticker)
    }
    
    fileprivate func defineLayout() {
        container.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(12)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        activityIndicatorView.snp.makeConstraints { (make) in
            make.center.equalTo(imageView)
        }
        
        button.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension ToolsView {
    func changeState(_ state: State) {
        switch state {
        case .delete:
            imageView.image = #imageLiteral(resourceName: "open_trash")
            titleLabel.text = "Let go to remove the sticker"
            button.isEnabled = false
            activityIndicatorView.stopAnimating()
        case .dragging:
            imageView.image = #imageLiteral(resourceName: "closed_trash")
            titleLabel.text = "Drag sticker here to remove it"
            button.isEnabled = false
            activityIndicatorView.stopAnimating()
        case .sticker:
            imageView.image = #imageLiteral(resourceName: "stickers_navbar")
            titleLabel.text = "Press to find a sticker"
            button.isEnabled = true
            activityIndicatorView.stopAnimating()
        case .loading:
            imageView.image = nil
            titleLabel.text = "Preparing your image"
            button.isEnabled = false
            activityIndicatorView.startAnimating()
        }
    }
}
