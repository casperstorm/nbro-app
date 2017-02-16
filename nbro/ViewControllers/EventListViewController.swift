//
// Created by Casper Storm Larsen on 02/02/16.
// Copyright (c) 2016 Bob. All rights reserved.
//

import UIKit
import Nuke

class EventListViewController: UIViewController {
    var contentView = EventListView()
    override func loadView() {
        super.loadView()
        view = contentView
        view.clipsToBounds = true
    }
    var events: [Event] = []
    let interactor = Interactor()
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        
        if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            registerForPreviewing(with: self, sourceView: view)
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.present(viewControllerToCommit, animated: true, completion: nil)
    }
    
    func applicationWillEnterForeground() {
        self.contentView.animateBackgroundImage()
    }
    
    func applicationDidEnterBackground() {
        contentView.stopBackgroundAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingManager.trackEvent(.viewEventList)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)

        contentView.animateBackgroundImage()
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.contentView.setNeedsUpdateConstraints()
        self.contentView.showNotAuthenticatedView = !FacebookManager.authenticated()
    }

    fileprivate func setupSubviews() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.refreshControl.addTarget(self, action: #selector(shouldRefreshData), for: .valueChanged)
        contentView.notAuthenticatedView.loginButton.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
    }
}

extension EventListViewController {
    dynamic fileprivate func loginPressed() {
        let loginViewController = LoginViewController()
        present(loginViewController, animated: true) { () -> Void in
            self.contentView.showNotAuthenticatedView = false
            self.contentView.didPresentUserButtons = false
            self.events = []
            self.contentView.tableView.reloadData()
        }
    }
}

extension EventListViewController {
    func shouldRefreshData() {
        loadData()
    }
    
    fileprivate func loadData() {
        FacebookManager.NBROEvents({ (events) -> Void in
            let animate = self.events.count == 0
            self.contentView.refreshControl.endRefreshing()
            
            self.events = events
            self.contentView.tableView.reloadData()
            self.animateCellsEntrance(animate)
        }, failure: {
        })
    }
}

extension EventListViewController {
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
}

extension EventListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath) as! EventCell
        let event = events[indexPath.row]
        cell.nameLabelText(event.name.uppercased())
        cell.dateLabel.text = "\(event.formattedStartDate(.relative(fallback: .date(includeYear: true)))) at \(event.formattedStartDate(.time))".uppercased()
        
        return cell
    }
}

extension EventListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // iOS still contains weird bug where presenting something from didSelectRow can take a while
        DispatchQueue.main.async { () -> Void in
            UIView.animate(withDuration: 0.25, animations: {
                self.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9);
            })
            
            let event = self.events[indexPath.row]
            let eventDetailViewController = EventDetailViewController(event: event)
            eventDetailViewController.transitioningDelegate = self
            eventDetailViewController.interactor = self.interactor
            self.present(eventDetailViewController, animated: true, completion: {
                self.view.transform = CGAffineTransform.identity;
            })
        }
    }
}

extension EventListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

extension EventListViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let point = contentView.tableView.convert(location, from: contentView)
        guard let indexPath = contentView.tableView.indexPathForRow(at: point) else { return nil }
        let event = events[indexPath.row]
        let eventDetailViewController = EventDetailViewController(event: event)
        eventDetailViewController.transitioningDelegate = self
        eventDetailViewController.interactor = self.interactor
        
        return eventDetailViewController
    }
}

