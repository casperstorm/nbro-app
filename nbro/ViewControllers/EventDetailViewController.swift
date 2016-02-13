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
        contentView.mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 40.7326808,
            longitude: -73.9843407),
            zoomLevel: 12, animated: false)
    }
    
    // MARK: Actions
    
    func cancelPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}