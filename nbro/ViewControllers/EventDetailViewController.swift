//
//  EventDetailViewController.swift
//  nbro
//
//  Created by Peter Gammelgaard Poulsen on 13/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Mapbox
import L360Confetti

class EventDetailViewController: UIViewController, L360ConfettiAreaDelegate {
    
    var contentView = EventDetailView()
    override func loadView() {
        super.loadView()
        view = contentView
    }

    let event: Event
    var interactor:Interactor?
    
    init(event:Event) {
        self.event = event
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        setupActions()
        setupSubviews()
        
        evaluateAttendButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingManager.trackEvent(.viewEventDetail)
        setupMapView()
    }
    
    func applicationWillEnterForeground() {
        setupMapView()
    }
    
    fileprivate func setupMapView() {
        if let longitude = event.longitude, let latitude = event.latitude {
            let coordinate = CLLocationCoordinate2D(latitude: latitude,
                longitude: longitude)
            self.contentView.addAnnotationAtCoordinate(coordinate)
            
            let delayTime = DispatchTime.now() + Double(Int64(0.01 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.contentView.mapView.setCenter(coordinate,
                    zoomLevel: 14, animated: false)
                self.contentView.mapView.contentInset = UIEdgeInsets(top: -UIScreen.main.bounds.height/2 - 100, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    fileprivate func setupActions() {
        contentView.cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        contentView.facebookButton.addTarget(self, action: #selector(facebookPressed), for: .touchUpInside)
        contentView.panGestureRecognizer.addTarget(self, action: #selector(handleDismissGesture(_:)))
        contentView.eventView.attentButtonView.switchView.didSwipe = { [weak self] (isLeft: Bool) in
            if !isLeft {
                self?.attentEvent()
            } else {
                self?.declinetEvent()
            }
        }
    }
    
    fileprivate func setupSubviews() {
        contentView.eventView.titleLabel.text = event.name.uppercased()
        contentView.eventView.dateLabel.text = "\(event.formattedStartDate(.relative(fallback: .date(includeYear: true)))) at \(event.formattedStartDate(.time)) – \(event.locationName)".uppercased()
        contentView.eventView.descriptionTextWithAjustedLineHeight(event.description)

        refreshRunnersCount()
        contentView.eventView.confettiView.delegate = self
        contentView.eventView.attendeesButton.addTarget(self, action: #selector(attendeesButtonPressed), for: .touchUpInside)
        contentView.eventView.interestedButton.addTarget(self, action: #selector(interestedButtonPressed), for: .touchUpInside)
    }
    
    // MARK: Actions
    
    func attendeesButtonPressed() {
        let attendeesViewController = AttendeesViewController(event: event, state: .attendees)
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9);
        })
        
        attendeesViewController.transitioningDelegate = self
        self.present(attendeesViewController, animated: true, completion: {
            self.view.transform = CGAffineTransform.identity;
        })
    }
    
    func interestedButtonPressed() {
        let attendeesViewController = AttendeesViewController(event: event, state: .interested)
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9);
        })
        
        attendeesViewController.transitioningDelegate = self
        self.present(attendeesViewController, animated: true, completion: {
            self.view.transform = CGAffineTransform.identity;
        })
    }
    
    func cancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func facebookPressed() {
        TrackingManager.trackEvent(.visitEventInFacebook)
        UIApplication.shared.openURL(URL(string: "https://www.facebook.com/events/\(event.id)/")!)
    }
    
    func attentEvent() {
        TrackingManager.trackEvent(.attendEvent)
        if FacebookManager.userHasRSVPEventPermission() {
            // blast confetti:
            contentView.eventView.fireConfetti()
            
            FacebookManager.attentEvent(event) { (success, error) in
                if(success) {
                    self.refreshRunnersCount()
                } else {
                    self.contentView.eventView.attentButtonView.switchView.isLeft = true
                }
            }
        } else {
            FacebookManager.attentEvent(event) { (success, error) in
                if(success) {
                    self.contentView.eventView.fireConfetti()
                    self.refreshRunnersCount()
                } else {
                   self.contentView.eventView.attentButtonView.switchView.isLeft = true
                }
            }
        }
    }
    
    func declinetEvent() {
        FacebookManager.declineEvent(event) { (success, error) -> Void in
            if(success) {
                self.refreshRunnersCount()
            } else {
                self.contentView.eventView.attentButtonView.switchView.isLeft = false
            }
        }
    }
    
    func handleDismissGesture(_ sender: UIPanGestureRecognizer) {
        let percentThreshold:CGFloat = 0.3
        let velocityThreshold:CGFloat = 1000
        
        // convert y-position to downward pull progress (percentage)
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        let velocity = sender.velocity(in: contentView)
        guard let interactor = interactor else { return }
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold || velocity.y > velocityThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }
    
    //MARK: Helpers
    
    func refreshRunnersCount() {
        self.contentView.eventView.attendingDetailView.titleLabel.text = "Attending".uppercased()
        self.contentView.eventView.interestedDetailView.titleLabel.text = "Interested".uppercased()
        
        FacebookManager.detailedEvent(event) { (result) in
            guard   let attending = result["attending_count"] as? Int,
                    let interested = result["interested_count"] as? Int else { return }
            
            self.setRunnersCount(attending, interested: interested)
        }
    }
    
    func setRunnersCount(_ attending: Int, interested: Int) {
        self.contentView.eventView.attendingDetailView.detailLabel.text = "\(attending)".uppercased()
        self.contentView.eventView.interestedDetailView.detailLabel.text = "\(interested)".uppercased()
    }
    
    //MARK: L360ConfettiAreaDelegate
    
    func colors(for confettiArea: L360ConfettiArea!) -> [Any]! {
        return [UIColor(hex: 0xFF5E5E), UIColor(hex: 0xFFD75E), UIColor(hex: 0x33DB96), UIColor(hex: 0xA97DBB), UIColor(hex: 0xCFCFCF), UIColor(hex: 0x2A7ADC)]
    }
    
    func evaluateAttendButton() {
        contentView.eventView.attentButtonView.startAnimating()
        FacebookManager.isAttendingEvent(event) { (attending) in
            self.contentView.eventView.attentButtonView.switchView.isLeft = !attending
                self.contentView.eventView.attentButtonView.stopAnimating()
        }
    }
}

extension EventDetailViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor!.hasStarted ? interactor : nil
    }
}

