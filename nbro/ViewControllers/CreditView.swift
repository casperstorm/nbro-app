//
//  CreditView.swift
//  nbro
//
//  Created by Casper Storm Larsen on 17/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class CreditView: UIView {
    let tableView = UITableView.tableView()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .blackColor()
        setupSubviews()
        defineLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let subviews = [tableView]
        subviews.forEach { addSubview($0) }
    }
    
    private func defineLayout() {
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(tableView.superview!)
        }
    }
}

private extension UITableView {
    static func tableView() -> UITableView {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.registerClass(CreditCell.self, forCellReuseIdentifier: "credit-cell")
        tableView.separatorColor = UIColor.clearColor()
        return tableView
    }
}