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
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HeadlineCell")
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}


extension AboutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "HeadlineCell", for: indexPath)
        cell.textLabel?.text = "hi"
        return cell

    }
}

extension AboutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}


/*
 func configureVersionCell(_ indexPath: IndexPath) -> UITableViewCell {
 let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "version-cell", for: indexPath) as! AboutVersionCell
 cell.nameLabel.text = "NBRO RUNNING APP"
 let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
 let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
 cell.versionLabel.text = "v. " + version + " (" + build + ")"
 return cell
 }
 */
