//
//  AppIconListViewController.swift
//  nbro
//
//  Created by Casper Rogild Storm on 26/01/2018.
//  Copyright © 2018 Bob. All rights reserved.
//

import Foundation
import UIKit

class AppIconListViewController: UIViewController {
    enum TableData: Int {
        case runner, written, skull, daf, runpartyrepeat
    }
    
    var contentView = AppIconListView()
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        navigationItem.title = "Icons".uppercased()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingManager.trackEvent(.viewAppIcons)
    }
    
    fileprivate func setupSubviews() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.tableView.register(AppIconCell.self, forCellReuseIdentifier: "icon-cell")
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

extension AppIconListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = TableData(rawValue: indexPath.row)
        let icon = UIApplication.shared.alternateIconName
        
        switch data! {
        case .runner:
            let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "icon-cell", for: indexPath) as! AppIconCell
            cell.titleLabel.text = "Default"
            cell.iconImageView.image = UIImage(named: "icon_default@3x")
            cell.disclousureImageView.isHidden = !(icon == nil)
            cell.bottomSeparatorView.isHidden = true
            return cell
        case .written:
            let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "icon-cell", for: indexPath) as! AppIconCell
            cell.titleLabel.text = "NBRO"
            cell.iconImageView.image = UIImage(named: "icon_alt_nbro@3x")
            cell.disclousureImageView.isHidden = !(icon == "ic_written")
            cell.bottomSeparatorView.isHidden = true
            return cell
        case .skull:
            let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "icon-cell", for: indexPath) as! AppIconCell
            cell.titleLabel.text = "Skull"
            cell.iconImageView.image = UIImage(named: "icon_alt_skull@3x")
            cell.disclousureImageView.isHidden = !(icon == "ic_skull")
            cell.bottomSeparatorView.isHidden = true
            return cell
        case .daf:
            let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "icon-cell", for: indexPath) as! AppIconCell
            cell.titleLabel.text = "DAF"
            cell.iconImageView.image = UIImage(named: "icon_alt_daf@3x")
            cell.disclousureImageView.isHidden = !(icon == "ic_daf")
            cell.bottomSeparatorView.isHidden = true
            return cell
        case .runpartyrepeat:
            let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "icon-cell", for: indexPath) as! AppIconCell
            cell.titleLabel.text = "Run Party Repeat"
            cell.iconImageView.image = UIImage(named: "icon_alt_runpartyrepeat@3x")
            cell.disclousureImageView.isHidden = !(icon == "ic_runpartyrepeat")
            return cell
        }
    }
}

extension AppIconListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = TableData(rawValue: indexPath.row)
        switch data! {
        case .runner:
            UIApplication.shared.setAlternateIconName(nil) { _ in }
        case .written:
            UIApplication.shared.setAlternateIconName("ic_written") { _ in }
        case .skull:
            UIApplication.shared.setAlternateIconName("ic_skull") { _ in }
        case .daf:
            UIApplication.shared.setAlternateIconName("ic_daf") { _ in }
        case .runpartyrepeat:
            UIApplication.shared.setAlternateIconName("ic_runpartyrepeat") { _ in }
        }
        
        tableView.reloadData()
    }
}
