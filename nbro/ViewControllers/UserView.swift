//
//  UserView.swift
//  nbro
//
//  Created by Casper Storm Larsen on 22/03/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class UserView: UIView {
    let cancelButton = UIButton.cancelButton()
    let logoutButton = UIButton.logoutButton()
    let tableView = UITableView.tableView()
    let loadingView = UserLoadingView()
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
        let subviews = [loadingView, tableView, cancelButton, logoutButton]
        subviews.forEach { addSubview($0) }
    }
    
    fileprivate func defineLayout() {
        cancelButton.snp_makeConstraints { (make) -> Void in
            make.top.leading.equalTo(cancelButton.superview!).inset(EdgeInsetsMake(20, left: 10, bottom: 0, right: 0))
            make.width.height.equalTo(40)
        }
        
        logoutButton.snp_makeConstraints { (make) -> Void in
            make.top.trailing.equalTo(logoutButton.superview!).inset(EdgeInsetsMake(20, left: 0, bottom: 0, right: 15))
            make.height.equalTo(40)
        }
        
        loadingView.snp_makeConstraints { (make) in
            make.edges.equalTo(loadingView.superview!)
        }
        
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(tableView.superview!)
        }
    }
}

private extension UIButton {
    static func cancelButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_cancel"), for: UIControlState())
        
        return button
    }
    static func logoutButton() -> UIButton {
        let button = UIButton()
        let title = "Log out"
        let attrString = NSMutableAttributedString(string: title)
        attrString.addAttribute(NSKernAttributeName, value: 1.0, range: NSMakeRange(0, title.characters.count))
        attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor(hex: 0xf60085), range: NSMakeRange(0, title.characters.count))
        button.setAttributedTitle(attrString, for: UIControlState())
        button.titleLabel?.font = UIFont.defaultSemiBoldFontOfSize(14)
        return button
    }
}

private extension UITableView {
    static func tableView() -> UITableView {
        let tableView = UITableView()
        tableView.register(UserProfileCell.self, forCellReuseIdentifier: "user-cell")
        tableView.register(UserTextCell.self, forCellReuseIdentifier: "text-cell")
        tableView.register(UserEventCell.self, forCellReuseIdentifier: "event-cell")
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        tableView.alwaysBounceVertical = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        return tableView
    }
}
