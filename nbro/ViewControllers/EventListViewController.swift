//
// Created by Casper Storm Larsen on 02/02/16.
// Copyright (c) 2016 Bob. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum EventListType {
        case LogoCell
        case EventCell
    }
    
    var contentView = EventListView()
    override func loadView() {
        super.loadView()
        view = contentView
    }
    var events: [Event] = []
    let interactor = Interactor()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    func applicationWillEnterForeground() {
        self.contentView.animateBackgroundImage()
    }
    
    func applicationDidEnterBackground() {
        contentView.stopBackgroundAnimation()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillEnterForeground", name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)

        contentView.animateBackgroundImage()
        loadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    private func setupSubviews() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.aboutButton.addTarget(self, action: "aboutButtonPressed", forControlEvents: .TouchUpInside)
        contentView.refreshControl.addTarget(self, action: Selector("shouldRefreshData"), forControlEvents: .ValueChanged)
    }
    
    // MARK: Actions
    
    func aboutButtonPressed() {
//        let transitionManager = TransitionManager(style: .Swipe(reverse: false))
        let aboutViewController = AboutViewController()
        let navigationController = UINavigationController(rootViewController: aboutViewController)
//        navigationController.transitioningDelegate = transitionManager
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func shouldRefreshData() {
        loadData()
    }
    
    // MARK: Data
    
    private func loadData() {
        FacebookManager.events { (events) -> Void in
            let animate = self.events.count == 0
            self.contentView.refreshControl.endRefreshing()

            self.events = events
            self.contentView.tableView.reloadData()
            self.animateCellsEntrance(animate)
        }
    }
    
    // MARK: UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellType = cellTypeForIndexPath(indexPath)
        
        switch cellType {
        case .LogoCell:
            return configureLogoCell(indexPath)
        case .EventCell:
            return configureEventCell(indexPath)
        }
    }
    
    private func animateCellsEntrance(animate: Bool) {
        if(animate) {
            let visibleCells = contentView.tableView.visibleCells
            for index in 0 ..< visibleCells.count {
                let delay = (Double(index) * 0.04) + 0.3
                let cell = visibleCells[index]
                cell.transform = CGAffineTransformMakeTranslation(UIScreen.mainScreen().bounds.size.width - 120.0, 0)
                cell.alpha = 0
                UIView.animateWithDuration(0.9, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .CurveEaseOut, animations: {
                    cell.transform = CGAffineTransformIdentity
                    cell.alpha = 1.0
                    }, completion: nil)
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // iOS still contains weird bug where presenting something from didSelectRow can take a while
        let cellType = cellTypeForIndexPath(indexPath)
        if(cellType == .EventCell) {
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                let event = self.eventForIndexPath(indexPath)
                let eventDetailViewController = EventDetailViewController(event: event)
                eventDetailViewController.transitioningDelegate = self
                eventDetailViewController.interactor = self.interactor
                self.presentViewController(eventDetailViewController, animated: true, completion: nil)
            }
        } else if(cellType == .LogoCell) {
            contentView.animateBackgroundImageCrossfadeChange()
        }
    }
    
    // MARK : Cell Creation
    
    private func configureEventCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCellWithIdentifier("event", forIndexPath: indexPath) as! EventCell
        let event = eventForIndexPath(indexPath)
        cell.nameLabelText(event.name.uppercaseString)
        cell.dateLabel.text = "\(event.formattedStartDate(.Relative(fallback: .Date(includeYear: true)))) at \(event.formattedStartDate(.Time))".uppercaseString

        return cell
    }
    
    private func configureLogoCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCellWithIdentifier("logo", forIndexPath: indexPath) as! LogoCell
        return cell
    }
    
    // MARK : Helper
    
    private func cellTypeForIndexPath(indexPath: NSIndexPath) -> EventListType {
        if(indexPath.row == 0) {
            return EventListType.LogoCell
        } else {
            return EventListType.EventCell
        }
    }
    
    private func eventForIndexPath(indexPath: NSIndexPath) -> Event {
        return events[indexPath.row - 1]
    }
}

extension EventListViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

