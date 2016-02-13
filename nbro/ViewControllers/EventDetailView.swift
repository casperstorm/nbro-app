//
//  EventDetailView.swift
//  nbro
//
//  Created by Peter Gammelgaard Poulsen on 13/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Mapbox

class EventDetailView: UIView {
 
    let cancelButton = UIButton.cancelButton()
    let mapView = MGLMapView.eventMapView()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .blackColor()
        setupSubviews()
        defineLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let subviews = [mapView, cancelButton]
        subviews.forEach { addSubview($0) }
    }
    
    private func defineLayout() {
        mapView.snp_makeConstraints { (make) -> Void in
            make.top.leading.trailing.equalTo(mapView.superview!)
            make.height.equalTo(mapView.superview!).multipliedBy(0.32)
        }
        
        cancelButton.snp_makeConstraints { (make) -> Void in
            make.top.leading.equalTo(cancelButton.superview!).inset(EdgeInsetsMake(20, left: 10, bottom: 0, right: 0))
            make.width.height.equalTo(40)
        }
    }
}

private extension UIButton {
    static func cancelButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_cancel"), forState: .Normal)
        
        return button
    }
}

private extension MGLMapView {
    static func eventMapView() -> MGLMapView {
        // There is a bug where it needs a frame in init https://github.com/mapbox/mapbox-gl-native/issues/1572
        let frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        let mapView = MGLMapView(frame: frame, styleURL: MGLStyle.darkStyleURL())
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        mapView.attributionButton.hidden = true
        
        return mapView
    }
}