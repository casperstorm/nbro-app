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
        tableView.registerClass(EventCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor = UIColor.clearColor()

        return tableView
    }()
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        
        self.setupSubviews()
        self.defineLayout()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as! EventCell

        let event = self.events[indexPath.row]
//        cell.nameLabel.text = event.name?.uppercaseString
        cell.dateLabel.text = "12 Feb 2016"

        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let event = self.events[indexPath.row]
        let eventDetailViewController = EventDetailViewController(event: event)
        presentViewController(eventDetailViewController, animated: true, completion: nil)
    }
    
}
