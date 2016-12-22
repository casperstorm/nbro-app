//
//  AttendeesView.swift
//  nbro
//
//  Created by Casper Storm Larsen on 17/08/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class AttendeeCell: UITableViewCell {
    
    let topSeparatorView = UIView()
    let bottomSeparatorView = UIView()
    let profileImageView = UIImageView()
    let titleLabel = UILabel.profileNameLabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(hex: 0x101010)
        let highligtedView = UIView()
        highligtedView.backgroundColor = UIColor(hex: 0x2c2c2c)
        selectedBackgroundView = highligtedView
        
        let separatorColor = UIColor(hex: 0x2c2c2c)
        topSeparatorView.backgroundColor = separatorColor
        bottomSeparatorView.backgroundColor = separatorColor
        
        profileImageView.layer.cornerRadius = 22.5
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        self.layer.masksToBounds = true
        self.contentView.layer.masksToBounds = true

        setupSubviews()
        defineLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        contentView.addSubview(topSeparatorView)
        contentView.addSubview(bottomSeparatorView)
        contentView.addSubview(profileImageView)
        contentView.addSubview(titleLabel)
    }
    
    fileprivate func defineLayouts() {
        
        topSeparatorView.snp.makeConstraints { (make) in
            make.left.right.equalTo(topSeparatorView.superview!)
            make.top.equalTo(topSeparatorView.superview!)
            make.height.equalTo(0.5)
        }
        
        bottomSeparatorView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(bottomSeparatorView.superview!)
            make.height.equalTo(0.5)
        }
        
        profileImageView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(profileImageView.superview!).inset(10)
            make.left.equalTo(22)
            make.width.equalTo(45)
            make.height.equalTo(45)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profileImageView.snp.right).offset(22)
            make.centerY.equalTo(titleLabel.superview!)
            make.right.lessThanOrEqualTo(profileImageView.superview!).offset(-22)
        }
    }
}

class AttendeesView: UIView, UIGestureRecognizerDelegate {
    let cancelButton = UIButton.cancelButton()
    let tableView = UITableView.tableView()
    let loadingView = UserLoadingView()
    let titleLabel = UILabel.titleLabel()
    
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
        let subviews = [loadingView, tableView, cancelButton, titleLabel]
        subviews.forEach { addSubview($0) }
    }
    
    fileprivate func defineLayout() {
        cancelButton.snp.makeConstraints { (make) -> Void in
            make.top.leading.equalTo(cancelButton.superview!).inset(EdgeInsetsMake(20, left: 10, bottom: 0, right: 0))
            make.width.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(tableView.superview!)
            make.top.equalTo(cancelButton.snp.bottom).offset(20)
        }
        
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalTo(loadingView.superview!)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleLabel.superview!)
            make.centerY.equalTo(self.cancelButton).offset(5)
        }
    }
}

private extension UILabel {
    static func profileNameLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.defaultMediumFontOfSize(16)
        return label
    }
    static func titleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.titleBoldFontOfSize(30)
        label.textAlignment = .center
        return label
    }
}

private extension UIButton {
    static func cancelButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_cancel"), for: UIControlState())
        
        return button
    }
}

private extension UITableView {
    static func tableView() -> UITableView {
        let tableView = UITableView()
        tableView.register(AttendeeCell.self, forCellReuseIdentifier: "attendee-cell")
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        tableView.alwaysBounceVertical = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        return tableView
    }
}
