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
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        return tableView
    }()

    let gradient: UIImageView = {
        return UIImageView(image: #imageLiteral(resourceName: "about_gradient_shadow"))
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
        let subviews = [tableView, gradient]
        subviews.forEach { addSubview($0) }
    }
    
    fileprivate func defineLayout() {        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        gradient.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
        }
    }

}
