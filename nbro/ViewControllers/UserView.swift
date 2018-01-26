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
    let notAuthenticatedView = InformationView()
    let tableView = UITableView.tableView()
    let loadingView = LoadingView()
    let versionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.defaultLightFontOfSize(12)
        return label
    }()
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
        let subviews = [loadingView, tableView, versionLabel, notAuthenticatedView]
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
            make.center.equalToSuperview()
        }
        versionLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

private extension UITableView {
    static func tableView() -> UITableView {
        let tableView = UITableView()
        tableView.register(UserProfileCell.self, forCellReuseIdentifier: "user-cell")
        tableView.register(DetailCell.self, forCellReuseIdentifier: "detail-cell")
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        return tableView
    }
}
