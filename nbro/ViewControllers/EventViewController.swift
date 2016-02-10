//
// Created by Casper Storm Larsen on 02/02/16.
// Copyright (c) 2016 Bob. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.setupSubviews()
        self.defineLayout()
        self.loadData()
    }
    
    func setupSubviews() {
        self.view.addSubview(self.tableView)
    }

    func defineLayout() {
        let horizontalConstraint = self.tableView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
        let vertivalConstraint = self.tableView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor)
        let widthConstraint = self.tableView.widthAnchor.constraintEqualToAnchor(view.widthAnchor)
        let heightConstraint = self.tableView.heightAnchor.constraintEqualToAnchor(view.heightAnchor)
        NSLayoutConstraint.activateConstraints([horizontalConstraint, vertivalConstraint, widthConstraint, heightConstraint])
    }
    
    // MARK: Data
    
    func loadData() {
        FacebookManager.events { (events) -> Void in
            self.events = events
            self.tableView.reloadData()
        }
    }
    
    // MARK: UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell

        let event = self.events[indexPath.row]
        cell.textLabel?.text = event.name
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
}
