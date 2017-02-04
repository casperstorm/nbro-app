//
//  UserViewController.swift
//  nbro
//
//  Created by Casper Storm Larsen on 22/03/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import Nuke

fileprivate class ViewModel {
    enum TableData: Int {
        case profile, information, event
    }
    
    var events: [Event] = []
    var user: FacebookProfile?
  
    func loadUser(_ completion: @escaping (_ user: FacebookProfile?) -> Void) {
        FacebookManager.user(completion)
    }
    
    func loadEvents(_ completion: @escaping (Bool, [Event]?) -> Void) {
        FacebookManager.userEvents({ userEvents in
            FacebookManager.NBROEvents({ nbroEvents in
                let attendingEvents: [Event] = userEvents.filter({ event -> Bool in
                    let contains = nbroEvents.contains(event)
                    let attending = event.rsvp == .attending
                    return attending && contains
                })
                
                var sortedEvents = attendingEvents
                sortedEvents.sort(by: { $0.startDate.compare($1.startDate) == ComparisonResult.orderedAscending })
                completion(true, sortedEvents)
            }, failure: {
                completion(false, nil)
            })
        }, failure: {
            completion(false, nil)
        })
    }
}

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    fileprivate let viewModel = ViewModel()
    var contentView = UserView()
    let interactor = Interactor()
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingManager.trackEvent(.viewUser)
        prepareToLoadData()
    }

    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    func setupSubviews() {
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Profile".uppercased()
        
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let staticCells: [ViewModel.TableData] = [.profile, .information]
        let events = viewModel.events
        
        return staticCells.count + events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableDataRow(indexPath) {
        case .profile:
            let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "user-cell", for: indexPath) as! UserProfileCell
            viewModel.loadUser({ user in
                guard let user = user else { return }
                cell.userNameLabel.text = user.name.uppercased()
                Manager.shared.loadImage(with: user.imageURL, token: nil) { result in
                    switch result {
                    case .success(let image):
                        cell.userImageView.image = image.convertToGrayScale()
                    case .failure(let error):
                        print("Oh noes. Image could not be loaded: \(error.localizedDescription)")
                    }
                }
            })
            return cell
        case .information:
            let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "text-cell", for: indexPath) as! UserTextCell
            let events = viewModel.events
            if(events.count == 0) {
                cell.bodyLabel.text = "It looks like you don't have any upcoming events. Remember, your commitment will be rewarded mile by mile."
                
            } else {
                let count = events.count
                let pluralEvent = (count == 1) ? "event" : "events"
                cell.bodyLabel.text = "You have \(count) upcoming \(pluralEvent)!\nKeep it up, your commitment will be rewarded mile by mile."
            }
            return cell
        case .event:
            let event = viewModel.events[indexPath.row - 2]
            let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "event-cell", for: indexPath) as! UserEventCell
            cell.setTitleText(event.name.uppercased())
            cell.detailLabel.text = "\(event.formattedStartDate(.relative(fallback: .date(includeYear: true)))) at \(event.formattedStartDate(.time))".uppercased()
            cell.iconImageView.image = UIImage(named: "icon_event")
            return cell
        }

    }
    
    fileprivate func tableDataRow(_ indexPath: IndexPath) -> ViewModel.TableData {
        if(indexPath.row == 0) {
            return .profile
        } else if (indexPath.row == 1) {
            return .information
        } else {
            return .event
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentView.tableView.deselectRow(at: indexPath, animated: true)
        let data = tableDataRow(indexPath)
        switch data {
        case .event:
            DispatchQueue.main.async { () -> Void in
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9);
                })
                
                let event = self.viewModel.events[indexPath.row - 2]
                let eventDetailViewController = EventDetailViewController(event: event)
                eventDetailViewController.transitioningDelegate = self
                eventDetailViewController.interactor = self.interactor
                self.present(eventDetailViewController, animated: true, completion: {
                    self.view.transform = CGAffineTransform.identity;
                })
            }
        default: break;
        }
    }
}

extension UserViewController {
    dynamic fileprivate func loginPressed() {
        let loginViewController = LoginViewController()
        present(loginViewController, animated: true) { () -> Void in
            self.contentView.showNotAuthenticatedView = false
        }
    }
    
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
}

extension UserViewController {
    func prepareToLoadData() {
        let events = viewModel.events
        if events.count == 0 {
            contentView.tableView.isHidden = true
            presentLoadingAnimation()
        }
        
        let authenticated = FacebookManager.authenticated()
        contentView.notAuthenticatedView.isHidden = authenticated
        if(authenticated) {
            let logoutBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logoutPressed))
            navigationItem.rightBarButtonItem = logoutBarButtonItem
            
            loadData()
        }
    }
    
    func loadData() {
        viewModel.loadEvents { [weak self] success, events in
            guard let strongSelf = self else { return }
            if(success) {
                guard let events = events else { return }
                let shouldAnimateEntrance = strongSelf.viewModel.events.count == 0
                strongSelf.viewModel.events = events
                strongSelf.contentView.tableView.isHidden = false
                strongSelf.hideLoadingAnimation()
                strongSelf.contentView.tableView.reloadData()
                strongSelf.animateCellsEntrance(shouldAnimateEntrance)
            } else {
                strongSelf.presentErrorView()
            }
        }
    }
}

extension UserViewController {
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
    
    fileprivate func presentErrorView() {
        contentView.tableView.isHidden = true
        hideLoadingAnimation()

        UIView.animate(withDuration: 0.5, animations: {
            self.contentView.loadingView.statusLabel.alpha = 1.0
            }, completion: { (completed) in
        })
    }

    
    fileprivate func presentLoadingAnimation() {
        contentView.loadingView.activityIndicatorView.startAnimating()
    }
    
    fileprivate func hideLoadingAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.contentView.loadingView.activityIndicatorView.alpha = 0.0
            }, completion: { (completed) in
                self.contentView.loadingView.activityIndicatorView.stopAnimating()
                self.contentView.loadingView.activityIndicatorView.alpha = 1.0
        })
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
