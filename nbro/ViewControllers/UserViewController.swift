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
    
    enum UserCellType: Int {
        case profileCellType
        case textCellType
        case eventCellType
    }
    
    var contentView = UserView()
    let interactor = Interactor()
    var events: [Event] = []
    

    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationItem.title = "Profile".uppercased()
        self.contentView.tableView.isHidden = true
        loadData()
        
        let logoutBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logoutPressed))
        self.navigationItem.rightBarButtonItem = logoutBarButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingManager.trackEvent(.viewUser)
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func loadData() {
        FacebookManager.userEvents({ (userEvents) -> Void in
            FacebookManager.NBROEvents({ (nbroEvents) -> Void in
                for event in userEvents {
                    let contains = nbroEvents.contains(event)
                    let attending = event.rsvp == .attending
                    if contains && attending {
                        self.events.append(event)
                    }
                }
                self.events.sort(by: { $0.startDate.compare($1.startDate) == ComparisonResult.orderedAscending })
                self.contentView.tableView.isHidden = false
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
    
    fileprivate func animateCellsEntrance(_ animate: Bool) {
        if(animate) {
            let visibleCells = contentView.tableView.visibleCells
            for index in 0 ..< visibleCells.count {
                let delay = (Double(index) * 0.04) + 0.3
                let cell = visibleCells[index]
                cell.transform = CGAffineTransform(translationX: UIScreen.main.bounds.size.width - 120.0, y: 0)
                cell.alpha = 0
                UIView.animate(withDuration: 0.9, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                    cell.transform = CGAffineTransform.identity
                    cell.alpha = 1.0
                    }, completion: nil)
            }
        }
    }
    
    fileprivate func displayErrorMessage() {
        contentView.tableView.isHidden = true
        fadeoutLoadingIndicator()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.contentView.loadingView.statusLabel.alpha = 1.0
            }, completion: { (completed) in
        })
    }
    
    fileprivate func fadeoutLoadingIndicator() {
        UIView.animate(withDuration: 0.5, animations: {
            self.contentView.loadingView.activityIndicatorView.alpha = 0.0
            }, completion: { (completed) in
                self.contentView.loadingView.activityIndicatorView.stopAnimating()
                self.contentView.loadingView.activityIndicatorView.alpha = 1.0
        })
    }

    func setupSubviews() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
    }
    
    // MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = userCellTypeForIndexPath(indexPath)
        if(cellType == .profileCellType) {
            return configureUserProfileCell(indexPath)
        } else if(cellType == .textCellType) {
            return configureUserTextCell(indexPath)
        } else if(cellType == .eventCellType) {
            return configureUserEventCell(indexPath)
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentView.tableView.deselectRow(at: indexPath, animated: true)
        let cellType = userCellTypeForIndexPath(indexPath)
        if(cellType == .eventCellType) {
            DispatchQueue.main.async { () -> Void in
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9);
                })
                
                let event = self.events[indexPath.row - 2]
                let eventDetailViewController = EventDetailViewController(event: event)
                eventDetailViewController.transitioningDelegate = self
                eventDetailViewController.interactor = self.interactor
                self.present(eventDetailViewController, animated: true, completion: {
                    self.view.transform = CGAffineTransform.identity;
                })
            }
        }

    }
    
    // MARK : Cell Creation
    
    func configureUserProfileCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "user-cell", for: indexPath) as! UserProfileCell
        FacebookManager.user { (user) in
            cell.userNameLabel.text = user.name.uppercased()
            Manager.shared.loadImage(with: user.imageURL, token: nil) { result in
                switch result {
                case .success(let image):
                    cell.userImageView.image = image.convertToGrayScale()
                case .failure(let error):
                    print("Oh noes. Image could not be loaded: \(error.localizedDescription)")
                }
                
                
            }
        }
        return cell
    }
    
    func configureUserTextCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "text-cell", for: indexPath) as! UserTextCell
        if(events.count == 0) {
            cell.bodyLabel.text = "It looks like you don't have any upcoming events. Remember, your commitment will be rewarded mile by mile."

        } else {
            let count = events.count
            let pluralEvent = (count == 1) ? "event" : "events"
            cell.bodyLabel.text = "You have \(count) upcoming \(pluralEvent)!\nKeep it up, your commitment will be rewarded mile by mile."
        }
        return cell
    }
    
    func configureUserEventCell(_ indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row - 2]
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "event-cell", for: indexPath) as! UserEventCell
        cell.setTitleText(event.name.uppercased())
        cell.detailLabel.text = "\(event.formattedStartDate(.relative(fallback: .date(includeYear: true)))) at \(event.formattedStartDate(.time))".uppercased()
        cell.iconImageView.image = UIImage(named: "icon_event")
        return cell
    }
    
    //MARK: Actions
    
    dynamic fileprivate func logoutPressed() {
        let alertController = UIAlertController(title: nil, message: "Are you sure?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Log out", style: .default, handler: { (_) -> Void in
            TrackingManager.trackEvent(.logout)
            FacebookManager.logout()
            
            self.dismiss(animated: true, completion: { () -> Void in
            })
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) -> Void in
            
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Helpers
    
    func userCellTypeForIndexPath(_ indexPath: IndexPath) -> UserCellType {
        if(indexPath.row == 0) {
            return .profileCellType
        } else if (indexPath.row == 1) {
            return .textCellType
        } else {
            return .eventCellType
        }
    }
}

extension UserViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
