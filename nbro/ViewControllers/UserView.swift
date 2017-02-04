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
    var showNotAuthenticatedView = false {
        didSet {
            notAuthenticatedView.isHidden = !showNotAuthenticatedView
            tableView.isHidden = showNotAuthenticatedView
            
            if showNotAuthenticatedView && !oldValue {
                notAuthenticatedView.alpha = 0.0
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.notAuthenticatedView.alpha = 1.0
                })
                
            }
        }
    }
    let notAuthenticatedView = NotAuthenticatedView()
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
        let subviews = [loadingView, tableView, notAuthenticatedView]
        subviews.forEach { addSubview($0) }
    }
    
    fileprivate func defineLayout() {
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalTo(loadingView.superview!)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(tableView.superview!)
        }
        notAuthenticatedView.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(notAuthenticatedView.superview!)
            make.leading.trailing.equalTo(notAuthenticatedView.superview!).inset(50)
        }
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
