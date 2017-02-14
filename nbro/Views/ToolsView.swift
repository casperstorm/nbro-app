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
        case sticker, dragging, delete
    }
    
    let container = UIView()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.defaultLightFontOfSize(15)
        label.text = "Press here to bla bla".uppercased()
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
        case .dragging:
            imageView.image = #imageLiteral(resourceName: "closed_trash")
            titleLabel.text = "Drag sticker here to remove it"
            button.isEnabled = false
        case .sticker:
            imageView.image = #imageLiteral(resourceName: "stickers_navbar")
            titleLabel.text = "Press to find a sticker"
            button.isEnabled = true
        }
    }
}
