//
//  AttendeesViewController.swift
//  nbro
//
//  Created by Casper Storm Larsen on 17/08/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit
import Nuke

public enum State {
    case Attendees
    case Interested
}

class AttendeesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var contentView = AttendeesView()
    let event: Event
    let state: State
    let interactor = Interactor()
    var attendees: [FacebookProfile] = []
    
    
    init(event: Event, state: State) {
        self.event = event
        self.state = state
    
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        self.contentView.tableView.hidden = true
        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        TrackingManager.trackEvent(.ViewAttendees)
    }
    
    func setupSubviews() {
        contentView.cancelButton.addTarget(self, action: #selector(cancelPressed), forControlEvents: .TouchUpInside)
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        
        switch(state) {
            case .Attendees:
                self.contentView.titleLabel.text = "Attending".uppercaseString
            case .Interested:
                self.contentView.titleLabel.text = "Interested".uppercaseString
        }
    }
    
    //MARK: Data
    
    private func loadData() {
        
        if state == .Attendees {
            FacebookManager.attendeesForEvent(event) { (result) in
                guard let dict = result["attending"], let dataArray = dict["data"] as? [NSDictionary] else { return }
                self.attendees = dataArray.map({ (data) -> FacebookProfile in
                    return FacebookProfile(dictionary: data)!
                })
                self.contentView.tableView.hidden = false
                self.fadeoutLoadingIndicator()
                self.contentView.tableView.reloadData()
                self.animateCellsEntrance(true)
            }
        } else if state == .Interested {
            FacebookManager.interestedForEvent(event) { (result) in
                guard let dict = result["maybe"], let dataArray = dict["data"] as? [NSDictionary] else { return }
                self.attendees = dataArray.map({ (data) -> FacebookProfile in
                    return FacebookProfile(dictionary: data)!
                })
                self.contentView.tableView.hidden = false
                self.fadeoutLoadingIndicator()
                self.contentView.tableView.reloadData()
                self.animateCellsEntrance(true)
            }
        }
    }
    
    
    // MARK: UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendees.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCellWithIdentifier("attendee-cell", forIndexPath: indexPath) as! AttendeeCell
        let attendee = attendees[indexPath.row]
        cell.titleLabel .text = attendee.name
        cell.profileImageView.image = nil
        
        let request = ImageRequest(URLRequest: NSURLRequest(URL: attendee.imageURL))
        Nuke.taskWith(request) { response in
            switch response {
            case let .Success(image, _):
                cell.profileImageView.image = image.convertToGrayScale()
            case .Failure(_): break
            }
            }.resume()
        
        
        if(indexPath.row < attendees.count - 1) {
            cell.bottomSeparatorView.hidden = true
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let attendee = attendees[indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/\(attendee.id)/")!)
    }

    
    //MARK: Actions
    
    func cancelPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Helpers
    
    private func fadeoutLoadingIndicator() {
        UIView.animateWithDuration(0.5, animations: {
            self.contentView.loadingView.activityIndicatorView.alpha = 0.0
            }, completion: { (completed) in
                self.contentView.loadingView.activityIndicatorView.stopAnimating()
                self.contentView.loadingView.activityIndicatorView.alpha = 1.0
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
    
}
