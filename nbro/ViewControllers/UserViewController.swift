//
//  UserViewController.swift
//  nbro
//
//  Created by Casper Storm Larsen on 22/03/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import Nuke

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var contentView = UserView()
    var interactor:Interactor?
    var events: [Event] = []
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        TrackingManager.trackEvent(.ViewUser)
        self.contentView.tableView.hidden = true
        loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBarHidden = true
        self.contentView.tableView.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    private func loadData() {
        FacebookManager.userEvents({ (userEvents) -> Void in
            FacebookManager.NBROEvents({ (nbroEvents) -> Void in
                for event in userEvents {
                    let contains = nbroEvents.contains(event)
                    if contains {
                        self.events.append(event)
                    }
                }
                self.events.sortInPlace({ $0.startDate.compare($1.startDate) == NSComparisonResult.OrderedAscending })
                self.contentView.tableView.hidden = false
                self.fadeoutLoadingIndicator()
                self.contentView.tableView.reloadData()
                self.animateCellsEntrance(true)
                }, failure: {
                    self.displayErrorMessage()
            })
            }, failure: {
                self.displayErrorMessage()
        })
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
    
    private func displayErrorMessage() {
        contentView.tableView.hidden = true
        fadeoutLoadingIndicator()
        
        UIView.animateWithDuration(0.5, animations: {
            self.contentView.loadingView.statusLabel.alpha = 1.0
            }, completion: { (completed) in
        })
    }
    
    private func fadeoutLoadingIndicator() {
        UIView.animateWithDuration(0.5, animations: {
            self.contentView.loadingView.activityIndicatorView.alpha = 0.0
            }, completion: { (completed) in
                self.contentView.loadingView.activityIndicatorView.stopAnimating()
                self.contentView.loadingView.activityIndicatorView.alpha = 1.0
        })
    }

    func setupSubviews() {
        contentView.cancelButton.addTarget(self, action: #selector(cancelPressed), forControlEvents: .TouchUpInside)
        contentView.logoutButton.addTarget(self, action: #selector(logoutPressed), forControlEvents: .TouchUpInside)
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
    }
    
    // MARK: UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count + 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.row == 0) {
            return configureUserProfileCell(indexPath)
        } else if(indexPath.row == 1) {
            return configureUserTextCell(indexPath)
        } else {
            return configureUserEventCell(indexPath)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    // MARK : Cell Creation
    
    func configureUserProfileCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCellWithIdentifier("user-cell", forIndexPath: indexPath) as! UserProfileCell
        FacebookManager.user { (user) in
            cell.userNameLabel.text = user.name.uppercaseString
            let request = ImageRequest(URLRequest: NSURLRequest(URL: user.imageURL))
            Nuke.taskWith(request) { response in
                switch response {
                case let .Success(image, _):
                    cell.userImageView.image = image.convertToGrayScale()
                case .Failure(_): break
                }
                }.resume()
        }
        return cell
    }
    
    func configureUserTextCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCellWithIdentifier("text-cell", forIndexPath: indexPath) as! UserTextCell
        if(events.count == 0) {
            cell.bodyLabel.text = "It looks like you don't have any upcoming events."

        } else {
            let count = events.count
            cell.bodyLabel.text = "You have \(count) upcoming events!"
        }
        return cell
    }
    
    func configureUserEventCell(indexPath: NSIndexPath) -> UITableViewCell {
        let event = events[indexPath.row - 2]
        let cell = contentView.tableView.dequeueReusableCellWithIdentifier("event-cell", forIndexPath: indexPath) as! UserEventCell
        cell.setTitleText(event.name.uppercaseString)
        cell.detailLabel.text = "\(event.formattedStartDate(.Relative(fallback: .Date(includeYear: true)))) at \(event.formattedStartDate(.Time))".uppercaseString
        cell.iconImageView.image = UIImage(named: "about_credit_icon")
        return cell
    }
    
    //MARK: Actions
    
    dynamic private func logoutPressed() {
        let alertController = UIAlertController(title: nil, message: "Are you sure?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Log out", style: .Default, handler: { (_) -> Void in
            TrackingManager.trackEvent(.Logout)
            FacebookManager.logout()
            
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
            })
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (_) -> Void in
            
        }))
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func cancelPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}