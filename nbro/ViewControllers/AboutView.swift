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
    let cancelButton = UIButton.cancelButton()
    let nameLabel = UILabel.nameLabel()
    let versionLabel = UILabel.versionLabel()
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
        let subviews = [tableView, cancelButton, nameLabel, versionLabel]
        subviews.forEach { addSubview($0) }
    }
    
    private func defineLayout() {
        cancelButton.snp_makeConstraints { (make) -> Void in
            make.top.leading.equalTo(cancelButton.superview!).inset(EdgeInsetsMake(20, left: 10, bottom: 0, right: 0))
            make.width.height.equalTo(40)
        }
        
        nameLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(nameLabel.superview!)
            make.bottom.equalTo(versionLabel.snp_top)
        }
        
        versionLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(versionLabel.superview!)
            make.bottom.equalTo(versionLabel.superview!).offset(-16)
        }
        
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(tableView.superview!)
        }
    }

}

private extension UITableView {
    static func tableView() -> UITableView {
        let tableView = UITableView()
        tableView.registerClass(AboutLogoCell.self, forCellReuseIdentifier: "logo-cell")
        tableView.registerClass(AboutTextCell.self, forCellReuseIdentifier: "text-cell")
        tableView.registerClass(AboutActionCell.self, forCellReuseIdentifier: "appstore-action-cell")
        tableView.registerClass(AboutActionCell.self, forCellReuseIdentifier: "credits-action-cell")
        tableView.registerClass(AboutActionCell.self, forCellReuseIdentifier: "facebook-action-cell")
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor = UIColor.clearColor()
        return tableView
    }
}

private extension UIButton {
    static func cancelButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_cancel"), forState: .Normal)
        
        return button
    }
}

private extension UILabel {
    static func nameLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .whiteColor()
        label.textAlignment = .Center
        label.font = UIFont.defaultSemiBoldFontOfSize(14)
        label.text = "NBRO RUNNING APP"
        return label
    }
    
    static func versionLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .grayColor()
        label.textAlignment = .Center
        label.font = UIFont.defaultFontOfSize(14)
        let version = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        let build = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String
        label.text = "v. " + version + " (" + build + ")"
        return label
    }
}
