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
    var shownIndexes = NSMutableSet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubviews()
    }
    
    func applicationWillEnterForeground() {
        contentView.animateBackgroundImage()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillEnterForeground", name: UIApplicationWillEnterForegroundNotification, object: nil)
        contentView.animateBackgroundImage()
        self.loadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillEnterForegroundNotification, object: nil)
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
        self.contentView.aboutButton.addTarget(self, action: "aboutButtonPressed", forControlEvents: .TouchUpInside)
    }
    
    // MARK: Actions
    
    func aboutButtonPressed() {
        self.presentViewController(AboutViewController(), animated: true, completion: nil)
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
        if indexPath.row == 0 {
            return configureLogoCell(indexPath)
        } else {
            return configureEventCell(indexPath)
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !shownIndexes.containsObject(indexPath) {
            shownIndexes.addObject(indexPath)
            cell.alpha = 0
            UIView.animateWithDuration(1.0) {
                cell.alpha = 1
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return LogoCell.preferredCellHeight()
        } else {
            let event = self.events[indexPath.row - 1]
            return EventCell.calculatedHeightForCellWithText(event.name)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // iOS still contains weird bug where presenting something from didSelectRow can take a while
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let event = self.events[indexPath.row]
            let eventDetailViewController = EventDetailViewController(event: event)
            self.presentViewController(eventDetailViewController, animated: true, completion: nil)
        }
    }
    
    // MARK : Cell Creation
    
    func configureEventCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCellWithIdentifier("event", forIndexPath: indexPath) as! EventCell
        let event = self.events[indexPath.row - 1]
//        cell.nameLabel.text = event.name.uppercaseString
        cell.dateLabel.text = "\(event.formattedStartDate(.Date(includeYear: true))) at \(event.formattedStartDate(.Time))"
        
        return cell
    }
    
    func configureLogoCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCellWithIdentifier("logo", forIndexPath: indexPath) as! LogoCell
        return cell
    }
    
}
