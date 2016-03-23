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
        
        FacebookManager.userEvents({ (events) in
            print(events)
            }) { (Void) in
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        TrackingManager.trackEvent(.ViewUser)
        loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    private func loadData() {
        FacebookManager.NBROEvents({ (events) in
            
        }, failure: {
                
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
        return 5
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
            cell.userImageView.alpha = 0.0
            Nuke.taskWith(request) { response in
                switch response {
                case let .Success(image, _):
                    cell.userImageView.image = image.convertToGrayScale()
                    UIView.animateWithDuration(1.00, animations: {
                        cell.userImageView.alpha = 1.0
                    })
                case .Failure(_): break
                }
                }.resume()
        }
        return cell
    }
    
    func configureUserTextCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCellWithIdentifier("text-cell", forIndexPath: indexPath) as! UserTextCell
        cell.bodyLabel.text = "has been attending 12 events from Islands Brygge, Copenhagen member since February 2017"
        return cell
    }
    
    func configureUserEventCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCellWithIdentifier("event-cell", forIndexPath: indexPath) as! UserEventCell
        cell.setTitleText("Credits".uppercaseString)
        cell.detailLabel.text = "Søpavillionen, København"
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