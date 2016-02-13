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

class EventListView: UIView {
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
        addSubview(tableView)
    }
    
    private func defineLayout() {
        tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(tableView.superview!)
        }
    }

}

private extension UITableView {
    static func tableView() -> UITableView {
        let tableView = UITableView()
        tableView.registerClass(EventCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor = UIColor.clearColor()
        return tableView
    }
}
