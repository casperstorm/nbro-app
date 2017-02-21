//
//  AboutViewController.swift
//  nbro
//
//  Created by Casper Storm Larsen on 15/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController: UIViewController {
    enum TableData: Int {
        case logo, text
    }
    
    var contentView = AboutView()

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
        
        contentView.versionLabel.text = applicationVersionString()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingManager.trackEvent(.viewAbout)
    }
    
    fileprivate func setupSubviews() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.tableView.register(AboutLogoCell.self, forCellReuseIdentifier: "LogoCell")
        contentView.tableView.register(AboutTextCell.self, forCellReuseIdentifier: "TextCell")
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

extension AboutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = TableData(rawValue: indexPath.row)
        switch data! {
        case .logo:
            let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "LogoCell", for: indexPath) as! AboutLogoCell
            cell.logoImageView.image = #imageLiteral(resourceName: "nbro_logo")
            return cell
        case .text:
            let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! AboutTextCell
            cell.titleLabel.text = "WE ARE NBRO RUNNERS OF COPENHAGEN.\nWE RUN THIS CITY."
            cell.contentLabel.text = "NBRO is a running community for passionate runners with a thing for sneakers and social get-togethers.\n\nNBRO is without king, territory or rules. Everyone is welcome to join the 6+ weekly training events starting from Søpavillionen at the Lakes in the heart of Copenhagen. Our training is fun and varied for runners of all levels and comprises of cross, core and interval training as well as distances a mile too long."
            return cell
        }
    }
}

extension AboutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension AboutViewController {
    func applicationVersionString() -> String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
        
        return version + " (" + build + ")"
    }
}

