//
//  CreditViewController.swift
//  nbro
//
//  Created by Casper Storm Larsen on 17/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class CreditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum CreditCellType: Int {
        case Casper = 0
        case Rasmus
        case Peter
        
        case TotalAmount
    }
    
    var contentView = CreditView()
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        self.title = "Credits".uppercaseString
    }
    
    private func setupSubviews() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CreditCellType.TotalAmount.rawValue
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellType = CreditCellType(rawValue: indexPath.row)!
        return configureCreditCell(indexPath, cellType: cellType)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CreditCell.preferredCellHeight()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cellType = CreditCellType(rawValue: indexPath.row)!
        switch(cellType) {
        case .Casper:
            UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/casperstorm")!)
        case .Rasmus:
            UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/rasmusnielsen")!)
        case .Peter:
            UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/petergam")!)
        default: break
        }
    }
    
    //MARK: Cell creation
    
    func configureCreditCell(indexPath: NSIndexPath, cellType: CreditCellType) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCellWithIdentifier("credit-cell", forIndexPath: indexPath) as! CreditCell
        cell.iconImageView.image = UIImage(named: "icon_mask")
        cell.detailIconImageView.image = UIImage(named: "icon_twitter")
        switch(cellType) {
        case .Casper:
            cell.bottomSeparatorView.hidden = true
            cell.titleLabel.text = "Casper Storm Larsen".uppercaseString
            cell.detailLabel.text = "Code".uppercaseString
            return cell
        case .Rasmus:
            cell.bottomSeparatorView.hidden = true
            cell.titleLabel.text = "Rasmus Nielsen".uppercaseString
            cell.detailLabel.text = "Design".uppercaseString
            return cell
        case .Peter:
            cell.titleLabel.text = "Peter Gammelgaard".uppercaseString
            cell.detailLabel.text = "Code".uppercaseString
            cell.bottomSeparatorView.hidden = false
            return cell
        default:
            return cell
        }
    }
}


