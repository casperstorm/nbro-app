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
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        setupActions()
        setupSubviews()
        
        evaluateAttendButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupMapView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        TrackingManager.trackEvent(.ViewEventDetail)
        setupMapView()
    }
    
    func applicationWillEnterForeground() {
        setupMapView()
    }
    
    private func setupMapView() {
        if let longitude = event.longitude, latitude = event.latitude {
            let coordinate = CLLocationCoordinate2D(latitude: latitude,
                longitude: longitude)
            self.contentView.addAnnotationAtCoordinate(coordinate)
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.01 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.contentView.mapView.setCenterCoordinate(coordinate,
                    zoomLevel: 14, animated: false)
                self.contentView.mapView.contentInset = UIEdgeInsets(top: -UIScreen.mainScreen().bounds.height/2 - 100, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    private func setupActions() {
        contentView.cancelButton.addTarget(self, action: #selector(cancelPressed), forControlEvents: .TouchUpInside)
        contentView.facebookButton.addTarget(self, action: #selector(facebookPressed), forControlEvents: .TouchUpInside)
        contentView.panGestureRecognizer.addTarget(self, action: #selector(handleDismissGesture(_:)))
        contentView.eventView.attentButtonView.switchView.didSwipe = { [weak self] (isLeft: Bool) in
            if !isLeft {
                self?.attentEvent()
            } else {
                self?.declinetEvent()
            }
        }
//        contentView.eventView.attentButtonView.button.addTarget(self, action: "attentEvent", forControlEvents: .TouchUpInside)
    }
    
    private func setupSubviews() {
        contentView.eventView.titleLabel.text = event.name.uppercaseString
        contentView.eventView.dateLabel.text = event.formattedStartDate(.Date(includeYear: true)).uppercaseString
        contentView.eventView.descriptionTextWithAjustedLineHeight(event.description)
        contentView.eventView.timeDetailView.titleLabel.text = "Time".uppercaseString
        contentView.eventView.timeDetailView.detailLabel.text = event.formattedStartDate(.Time).uppercaseString
        contentView.eventView.locationDetailView.titleLabel.text = "Location".uppercaseString
        contentView.eventView.locationDetailView.detailLabel.text = event.locationName.uppercaseString
        contentView.eventView.confettiView.delegate = self
    }
    
    // MARK: Actions
    
    func cancelPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func facebookPressed() {
        TrackingManager.trackEvent(.VisitEventInFacebook)
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/events/\(event.id)/")!)
    }
    
    func attentEvent() {
        TrackingManager.trackEvent(.AttendEvent)
        if FacebookManager.userHasRSVPEventPermission() {
            // blast confetti:
            contentView.eventView.fireConfetti()
            
            FacebookManager.attentEvent(event) { (success, error) in
                if(!success) {
                    self.contentView.eventView.attentButtonView.switchView.isLeft = true
                }
            }
        } else {
            FacebookManager.attentEvent(event) { (success, error) in
                if(success) {
                    self.contentView.eventView.fireConfetti()
                } else {
                   self.contentView.eventView.attentButtonView.switchView.isLeft = true
                }
            }
        }
    }
    
    func declinetEvent() {
        FacebookManager.declineEvent(event) { (success, error) -> Void in
            if(!success) {
                self.contentView.eventView.attentButtonView.switchView.isLeft = false
            }
        }
    }
    
    func handleDismissGesture(sender: UIPanGestureRecognizer) {
        let percentThreshold:CGFloat = 0.3
        let velocityThreshold:CGFloat = 1000
        
        // convert y-position to downward pull progress (percentage)
        let translation = sender.translationInView(view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        let velocity = sender.velocityInView(contentView)
        guard let interactor = interactor else { return }
        
        switch sender.state {
        case .Began:
            interactor.hasStarted = true
            dismissViewControllerAnimated(true, completion: nil)
        case .Changed:
            interactor.shouldFinish = progress > percentThreshold || velocity.y > velocityThreshold
            interactor.updateInteractiveTransition(progress)
        case .Cancelled:
            interactor.hasStarted = false
            interactor.cancelInteractiveTransition()
        case .Ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finishInteractiveTransition()
                : interactor.cancelInteractiveTransition()
        default:
            break
        }
    }
    
    //MARK: L360ConfettiAreaDelegate
    
    func colorsForConfettiArea(confettiArea: L360ConfettiArea!) -> [AnyObject]! {
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
