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

class EventDetailViewController: UIViewController {
    
    var contentView = EventDetailView()
    override func loadView() {
        super.loadView()
        view = contentView
    }

    let event: Event
    
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillEnterForeground", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        setupActions()
        setupSubviews()
        
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
        contentView.cancelButton.addTarget(self, action: "cancelPressed", forControlEvents: .TouchUpInside)
        contentView.facebookButton.addTarget(self, action: "facebookPressed", forControlEvents: .TouchUpInside)
    }
    
    private func setupSubviews() {
        contentView.eventView.titleLabel.text = event.name.uppercaseString
        contentView.eventView.dateLabel.text = event.formattedStartDate(.Date(includeYear: true)).uppercaseString
        contentView.eventView.descriptionLabel.text = event.description
        contentView.eventView.timeDetailView.titleLabel.text = "Time".uppercaseString
        contentView.eventView.timeDetailView.detailLabel.text = event.formattedStartDate(.Time).uppercaseString
        contentView.eventView.locationDetailView.titleLabel.text = "Location".uppercaseString
        contentView.eventView.locationDetailView.detailLabel.text = event.locationName.uppercaseString
    }
    
    // MARK: Actions
    
    func cancelPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func facebookPressed() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/events/\(event.id)/")!)
    }
    
}