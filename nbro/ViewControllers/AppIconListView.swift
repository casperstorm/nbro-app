//
//  AppIconListView.swift
//  nbro
//
//  Created by Casper Rogild Storm on 26/01/2018.
//  Copyright © 2018 Bob. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class AppIconListView: UIView {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        return tableView
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
        let subviews = [tableView]
        subviews.forEach { addSubview($0) }
    }
    
    fileprivate func defineLayout() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
