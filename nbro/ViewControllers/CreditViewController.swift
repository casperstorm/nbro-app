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
        case casper = 0
        case rasmus
        case peter
        
        case totalAmount
    }
    
    var contentView = CreditView()
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        self.title = "Credits".uppercased()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingManager.trackEvent(.viewCredits)
    }
    
    fileprivate func setupSubviews() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CreditCellType.totalAmount.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = CreditCellType(rawValue: indexPath.row)!
        return configureCreditCell(indexPath, cellType: cellType)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellType = CreditCellType(rawValue: indexPath.row)!
        switch(cellType) {
        case .casper:
            UIApplication.shared.openURL(URL(string: "https://twitter.com/casperstorm")!)
        case .rasmus:
            UIApplication.shared.openURL(URL(string: "https://twitter.com/rasmusnielsen")!)
        case .peter:
            UIApplication.shared.openURL(URL(string: "https://twitter.com/petergam")!)
        default: break
        }
    }
    
    //MARK: Cell creation
    
    func configureCreditCell(_ indexPath: IndexPath, cellType: CreditCellType) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "credit-cell", for: indexPath) as! CreditCell
        cell.iconImageView.image = UIImage(named: "icon_mask")
        cell.detailIconImageView.image = UIImage(named: "icon_twitter")
        switch(cellType) {
        case .casper:
            cell.bottomSeparatorView.isHidden = true
            cell.titleLabel.text = "Casper Storm Larsen".uppercased()
            cell.detailLabel.text = "Code".uppercased()
            return cell
        case .rasmus:
            cell.bottomSeparatorView.isHidden = true
            cell.titleLabel.text = "Rasmus Nielsen".uppercased()
            cell.detailLabel.text = "Design".uppercased()
            return cell
        case .peter:
            cell.titleLabel.text = "Peter Gammelgaard".uppercased()
            cell.detailLabel.text = "Code".uppercased()
            cell.bottomSeparatorView.isHidden = false
            return cell
        default:
            return cell
        }
    }
}


