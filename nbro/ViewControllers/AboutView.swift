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
        let subviews = [tableView]
        subviews.forEach { addSubview($0) }
    }
    
    fileprivate func defineLayout() {        
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
