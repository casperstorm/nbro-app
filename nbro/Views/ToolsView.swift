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
        backgroundColor = .black
        
        addSubview(button)
        addSubview(imageView)
        addSubview(activityIndicatorView)

        changeState(.sticker)
    }
    
    fileprivate func defineLayout() {
        
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
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
            button.isEnabled = false
            activityIndicatorView.stopAnimating()
        case .dragging:
            imageView.image = #imageLiteral(resourceName: "closed_trash")
            button.isEnabled = false
            activityIndicatorView.stopAnimating()
        case .sticker:
            imageView.image = #imageLiteral(resourceName: "add_stickers_icon")
            button.isEnabled = true
            activityIndicatorView.stopAnimating()
        case .loading:
            imageView.image = nil
            button.isEnabled = false
            activityIndicatorView.startAnimating()
        }
    }
}
