//
//  AboutView.swift
//  nbro
//
//  Created by Casper Storm Larsen on 15/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class AboutView: UIView {
    let cancelButton = UIButton.cancelButton()
    let tableView = UITableView.tableView()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .black
        setupSubviews()
        defineLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        let subviews = [tableView, cancelButton]
        subviews.forEach { addSubview($0) }
    }
    
    fileprivate func defineLayout() {
        cancelButton.snp.makeConstraints { (make) -> Void in
            make.top.leading.equalTo(cancelButton.superview!).inset(EdgeInsetsMake(20, left: 10, bottom: 0, right: 0))
            make.width.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(tableView.superview!)
        }
    }

}

private extension UITableView {
    static func tableView() -> UITableView {
        let tableView = UITableView()
        tableView.register(AboutLogoCell.self, forCellReuseIdentifier: "logo-cell")
        tableView.register(AboutTextCell.self, forCellReuseIdentifier: "text-cell")
        tableView.register(AboutActionCell.self, forCellReuseIdentifier: "appstore-action-cell")
        tableView.register(AboutActionCell.self, forCellReuseIdentifier: "credits-action-cell")
        tableView.register(AboutActionCell.self, forCellReuseIdentifier: "facebook-action-cell")
        tableView.register(AboutActionCell.self, forCellReuseIdentifier: "instagram-action-cell")
        tableView.register(AboutVersionCell.self, forCellReuseIdentifier: "version-cell")
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        tableView.alwaysBounceVertical = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        return tableView
    }
}

private extension UIButton {
    static func cancelButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_cancel"), for: UIControlState())
        
        return button
    }
}
