//
// Created by Casper Storm Larsen on 02/02/16.
// Copyright (c) 2016 Bob. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var contentView = EventListView()
    override func loadView() {
        super.loadView()
        view = contentView
    }
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubviews()
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
        self.contentView.tableView.dataSource = self
        self.contentView.tableView.delegate = self
    }
    
    // MARK: Data
    
    func loadData() {
        FacebookManager.events { (events) -> Void in
            self.events = events
            self.contentView.tableView.reloadData()
        }
    }
    
    // MARK: UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as! EventCell

        let event = self.events[indexPath.row]
        cell.nameLabel.text = event.name?.uppercaseString
        cell.dateLabel.text = "12 Feb 2016"

        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let event = self.events[indexPath.row]
        return EventCell.calculatedHeightForCellWithText(event.name)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // iOS still contains weird bug where presenting something from didSelectRow can take a while
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let event = self.events[indexPath.row]
            let eventDetailViewController = EventDetailViewController(event: event)
            self.presentViewController(eventDetailViewController, animated: true, completion: nil)
        }
    }
    
}
