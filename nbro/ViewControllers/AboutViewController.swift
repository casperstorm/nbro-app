//
//  AboutViewController.swift
//  nbro
//
//  Created by Casper Storm Larsen on 15/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum AboutCellType: Int {
        case LogoCell = 0
        case TextCell
        case AppStoreActionCell
        case FacebookActionCell
        case CreditsActionCell
        case VersionCell
        
        case Amount
    }
    
    var contentView = AboutView()
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    private func setupSubviews() {
        contentView.cancelButton.addTarget(self, action: "cancelPressed", forControlEvents: .TouchUpInside)
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: Actions
    
    func cancelPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AboutCellType.Amount.rawValue
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellType = AboutCellType(rawValue: indexPath.row)!
        switch cellType {
        case .LogoCell:
            return configureLogoCell(indexPath)
        case .TextCell:
            return configureTextCell(indexPath)
        case .AppStoreActionCell:
            return configureAppStoreActionCell(indexPath)
        case .FacebookActionCell:
            return configureFacebookActionCell(indexPath)
        case .CreditsActionCell:
            return configureCreditsActionCell(indexPath)
        case .VersionCell:
            return configureVersionCell(indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellType = AboutCellType(rawValue: indexPath.row)!
        switch cellType {
        case .LogoCell:
            return AboutLogoCell.preferredCellHeight()
        case .TextCell:
            return AboutTextCell.preferredCellHeight()
        case .AppStoreActionCell:
            return AboutActionCell.preferredCellHeight()
        case .FacebookActionCell:
            return AboutActionCell.preferredCellHeight()
        case .CreditsActionCell:
            return AboutActionCell.preferredCellHeight()
        case .VersionCell:
            return AboutVersionCell.preferredCellHeight()
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    // MARK : Cell Creation
    
    func configureLogoCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCellWithIdentifier("logo-cell", forIndexPath: indexPath) as! AboutLogoCell
        return cell
    }
    
    func configureTextCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCellWithIdentifier("text-cell", forIndexPath: indexPath) as! AboutTextCell
        cell.headerLabel.text = "NBRO RUNNING"
        cell.bodyLabel.text = "NBRO is a club for passionate runners with a thing for sneakers and get-togethers. NBRO is without king, territory or rules. Everyone is welcome to join the 4+ weekly training sessions."
        
        return cell
    }
    
    func configureAppStoreActionCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCellWithIdentifier("appstore-action-cell", forIndexPath: indexPath) as! AboutActionCell
        cell.titleLabel.text = "Rate in App Store".uppercaseString
        cell.bottomSeparatorView.hidden = true
        return cell
    }
    
    func configureFacebookActionCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCellWithIdentifier("facebook-action-cell", forIndexPath: indexPath) as! AboutActionCell
        cell.titleLabel.text = "NBRO Running Facebook".uppercaseString
        cell.bottomSeparatorView.hidden = true
        return cell
    }
    
    func configureCreditsActionCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCellWithIdentifier("credits-action-cell", forIndexPath: indexPath) as! AboutActionCell
        cell.titleLabel.text = "Credits".uppercaseString
        return cell
    }
    
    func configureVersionCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCellWithIdentifier("version-cell", forIndexPath: indexPath) as! AboutVersionCell
        cell.nameLabel.text = "NBRO RUNNING APP"
        let version = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        let build = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String
        cell.versionLabel.text = "v. " + version + " (" + build + ")"
        return cell
    }
}