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
        profileImageView.contentMode = .ScaleAspectFill
        
        self.layer.masksToBounds = true
        self.contentView.layer.masksToBounds = true

        setupSubviews()
        defineLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(topSeparatorView)
        contentView.addSubview(bottomSeparatorView)
        contentView.addSubview(profileImageView)
        contentView.addSubview(titleLabel)
    }
    
    private func defineLayouts() {
        
        topSeparatorView.snp_makeConstraints { (make) in
            make.left.right.equalTo(topSeparatorView.superview!)
            make.top.equalTo(topSeparatorView.superview!)
            make.height.equalTo(0.5)
        }
        
        bottomSeparatorView.snp_makeConstraints { (make) in
            make.bottom.left.right.equalTo(bottomSeparatorView.superview!)
            make.height.equalTo(0.5)
        }
        
        profileImageView.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(profileImageView.superview!).inset(10)
            make.left.equalTo(22)
            make.width.equalTo(45)
            make.height.equalTo(45)
        }
        
        titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(profileImageView.snp_right).offset(22)
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
        backgroundColor = .blackColor()
        setupSubviews()
        defineLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let subviews = [loadingView, tableView, cancelButton, titleLabel]
        subviews.forEach { addSubview($0) }
    }
    
    private func defineLayout() {
        cancelButton.snp_makeConstraints { (make) -> Void in
            make.top.leading.equalTo(cancelButton.superview!).inset(EdgeInsetsMake(20, left: 10, bottom: 0, right: 0))
            make.width.height.equalTo(40)
        }
        
        tableView.snp_makeConstraints { (make) in
            make.left.bottom.right.equalTo(tableView.superview!)
            make.top.equalTo(cancelButton.snp_bottom).offset(20)
        }
        
        loadingView.snp_makeConstraints { (make) in
            make.edges.equalTo(loadingView.superview!)
        }
        
        titleLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(titleLabel.superview!)
            make.centerY.equalTo(self.cancelButton).offset(5)
        }
    }
}

private extension UILabel {
    static func profileNameLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .whiteColor()
        label.textAlignment = .Left
        label.font = UIFont.defaultMediumFontOfSize(16)
        return label
    }
    static func titleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .whiteColor()
        label.font = UIFont.titleBoldFontOfSize(30)
        label.textAlignment = .Center
        return label
    }
}

private extension UIButton {
    static func cancelButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_cancel"), forState: .Normal)
        
        return button
    }
}

private extension UITableView {
    static func tableView() -> UITableView {
        let tableView = UITableView()
        tableView.registerClass(AttendeeCell.self, forCellReuseIdentifier: "attendee-cell")
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor = UIColor.clearColor()
        tableView.alwaysBounceVertical = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        return tableView
    }
}