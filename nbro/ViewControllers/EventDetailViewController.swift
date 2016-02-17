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
        
        setupActions()
        setupSubviews()
    }
    
    private func setupActions() {
        contentView.cancelButton.addTarget(self, action: "cancelPressed", forControlEvents: .TouchUpInside)
    }
    
    private func setupSubviews() {
        
        if let longitude = event.longitude, latitude = event.latitude {
            contentView.mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: latitude,
                longitude: longitude),
                zoomLevel: 12, animated: false)
        }
        
        contentView.eventView.titleLabel.text = event.name.uppercaseString
        contentView.eventView.dateLabel.text = event.formattedStartDate(.Date(includeYear: true)).uppercaseString
        contentView.eventView.descriptionLabel.text = event.description
    }
    
    // MARK: Actions
    
    func cancelPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}