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
        case logoCell = 0
        case textCell
        case appStoreActionCell
        case instagramActionCell
        case facebookActionCell
        case creditsActionCell
        case versionCell
        
        case amount
    }
    
    var contentView = AboutView()
    var interactor:Interactor?

    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationItem.title = "About".uppercased()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingManager.trackEvent(.viewAbout)
    }
    
    fileprivate func setupSubviews() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    // MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AboutCellType.amount.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = AboutCellType(rawValue: indexPath.row)!
        switch cellType {
        case .logoCell:
            return configureLogoCell(indexPath)
        case .textCell:
            return configureTextCell(indexPath)
        case .appStoreActionCell:
            return configureAppStoreActionCell(indexPath)
        case .instagramActionCell:
            return configureInstagramActionCell(indexPath)
        case .facebookActionCell:
            return configureFacebookActionCell(indexPath)
        case .creditsActionCell:
            return configureCreditsActionCell(indexPath)
        case .versionCell:
            return configureVersionCell(indexPath)
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellType = AboutCellType(rawValue: indexPath.row)!
        switch cellType {
        case .appStoreActionCell:
            TrackingManager.trackEvent(.visitAppStore)
            UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/app/id1084299725")!)
        case .facebookActionCell:
            TrackingManager.trackEvent(.visitFacebook)
            UIApplication.shared.openURL(URL(string: "https://www.facebook.com/groups/108900355842020/")!)
        case .instagramActionCell:
            TrackingManager.trackEvent(.visitInstagram)
            UIApplication.shared.openURL(URL(string: "https://www.instagram.com/nbrorunning/")!)
        case .creditsActionCell:
            self.navigationController?.pushViewController(CreditViewController(), animated: true)
        default: break

        }
    }
    
    // MARK : Cell Creation
    
    func configureLogoCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "logo-cell", for: indexPath) as! AboutLogoCell
        return cell
    }
    
    func configureTextCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "text-cell", for: indexPath) as! AboutTextCell
        cell.bodyLabel.text = "NBRO is a club for passionate runners with a thing for sneakers and get-togethers. NBRO is without king, territory or rules. Everyone is welcome to join the 4+ weekly training sessions."
        
        return cell
    }
    
    func configureAppStoreActionCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "appstore-action-cell", for: indexPath) as! AboutActionCell
        cell.setTitleText("Rate in App Store".uppercased())
        cell.iconImageView.image = UIImage(named: "about_like_icon")
        return cell
    }
    
    func configureFacebookActionCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "facebook-action-cell", for: indexPath) as! AboutActionCell
        cell.setTitleText("NBRO Facebook".uppercased())
        cell.iconImageView.image = UIImage(named: "about_facebook_icon")
        return cell
    }
    
    func configureCreditsActionCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "credits-action-cell", for: indexPath) as! AboutActionCell
        cell.setTitleText("Credits".uppercased())
        cell.iconImageView.image = UIImage(named: "about_credit_icon")
        return cell
    }
    
    func configureVersionCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "version-cell", for: indexPath) as! AboutVersionCell
        cell.nameLabel.text = "NBRO RUNNING APP"
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
        cell.versionLabel.text = "v. " + version + " (" + build + ")"
        return cell
    }
    
    func configureInstagramActionCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "instagram-action-cell", for: indexPath) as! AboutActionCell
        cell.setTitleText("NBRO Instagram".uppercased())
        cell.iconImageView.image = UIImage(named: "about_instagram_icon")
        return cell
    }
}
