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
        case InstagramActionCell
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
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
        let transitionManager = TransitionManager(style: .Swipe(reverse: true))
        self.transitioningDelegate = transitionManager
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
        case .InstagramActionCell:
            return configureInstagramActionCell(indexPath)
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

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cellType = AboutCellType(rawValue: indexPath.row)!
        switch cellType {
        case .AppStoreActionCell:
            UIApplication.sharedApplication().openURL(NSURL(string: "itms-apps://itunes.apple.com/app/id1084299725")!)
        case .FacebookActionCell:
            UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/groups/108900355842020/")!)
        case .InstagramActionCell:
            UIApplication.sharedApplication().openURL(NSURL(string: "https://www.instagram.com/nbrorunning/")!)
        case .CreditsActionCell:
            self.navigationController?.pushViewController(CreditViewController(), animated: true)
        default: break

        }
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
        cell.setTitleText("Rate in App Store".uppercaseString)
        cell.bottomSeparatorView.hidden = true
        cell.iconImageView.image = UIImage(named: "about_like_icon")
        return cell
    }
    
    func configureFacebookActionCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCellWithIdentifier("facebook-action-cell", forIndexPath: indexPath) as! AboutActionCell
        cell.setTitleText("NBRO Facebook".uppercaseString)
        cell.bottomSeparatorView.hidden = true
        cell.iconImageView.image = UIImage(named: "about_facebook_icon")
        return cell
    }
    
    func configureCreditsActionCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCellWithIdentifier("credits-action-cell", forIndexPath: indexPath) as! AboutActionCell
        cell.setTitleText("Credits".uppercaseString)
        cell.iconImageView.image = UIImage(named: "about_credit_icon")
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
    
    func configureInstagramActionCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCellWithIdentifier("instagram-action-cell", forIndexPath: indexPath) as! AboutActionCell
        cell.setTitleText("NBRO Instagram".uppercaseString)
        cell.bottomSeparatorView.hidden = true
        cell.iconImageView.image = UIImage(named: "about_instagram_icon")
        return cell
    }
}