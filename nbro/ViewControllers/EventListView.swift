//
//  EventView.swift
//  nbro
//
//  Created by Casper Storm Larsen on 13/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class EventListView: UIView, CAAnimationDelegate {
    
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
    
    let tableView = UITableView.tableView()
    let refreshControl = UIRefreshControl.refreshControl()
    let notAuthenticatedView = InformationView()
    let loadingView = LoadingView()
    

    init() {
        super.init(frame: CGRect.zero)
        notAuthenticatedView.isHidden = true
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
        
        tableView.addSubview(refreshControl)
        
        if refreshControl.subviews.count > 0 {
            refreshControl.subviews[0].frame = CGRect(x: 0, y: 30, width: 0, height: 0)
        }
    }
    
    fileprivate func defineLayout() {
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalTo(loadingView.superview!)
        }
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(tableView.superview!)
        }
        
        notAuthenticatedView.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
        }
    }
}

private extension UIRefreshControl {
    static func refreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        return refreshControl
    }
}

private extension UITableView {
    static func tableView() -> UITableView {
        let tableView = UITableView()
        tableView.register(EventCell.self, forCellReuseIdentifier: "event")
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0)
        return tableView
    }
}

private extension UIButton {
    static func aboutButton() -> UIButton {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "about_button"), for: UIControlState())
        return button
    }
}
