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
    let mapOverlay = UIImageView(image: UIImage(named: "map_overlay"))
    private let scrollView = EventScrollView()
    let eventView = EventView()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .blackColor()
        setupSubviews()
        defineLayout()
        
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        let topInset = screenHeight * 0.32
        scrollView.topInset = Float(topInset)
        scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let subviews = [mapView, mapOverlay, cancelButton, scrollView]
        subviews.forEach { addSubview($0) }
        
        scrollView.addSubview(eventView)
    }
    
    private func defineLayout() {
        mapView.snp_makeConstraints { (make) -> Void in
            make.top.leading.trailing.equalTo(mapView.superview!)
            make.height.equalTo(mapView.superview!).multipliedBy(0.32)
        }
        
        mapOverlay.snp_makeConstraints { (make) -> Void in
            make.top.leading.trailing.equalTo(mapOverlay.superview!)
            make.height.equalTo(mapView.superview!).multipliedBy(0.35)
        }
        
        scrollView.snp_makeConstraints { (make) -> Void in
            make.leading.trailing.top.bottom.equalTo(scrollView.superview!).inset(EdgeInsetsMake(0, left: 7, bottom: 0, right: 7))
        }
        
        eventView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(eventView.superview!).inset(EdgeInsetsMake(0, left: 0, bottom: 7, right: 0))
            make.width.equalTo(eventView.superview!)
            make.height.greaterThanOrEqualTo(eventView.superview!).multipliedBy(0.67)
        }
        
        cancelButton.snp_makeConstraints { (make) -> Void in
            make.top.leading.equalTo(cancelButton.superview!).inset(EdgeInsetsMake(20, left: 10, bottom: 0, right: 0))
            make.width.height.equalTo(40)
        }
    }
}

class EventView: UIView {
    
    let titleLabel = UILabel.titleLabel()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .whiteColor()
        setupSubviews()
        defineLayout()
        
        layer.cornerRadius = 4
        layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let subviews = [titleLabel]
        subviews.forEach { addSubview($0) }
    }
    
    private func defineLayout() {
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.leading.trailing.top.bottom.equalTo(titleLabel.superview!).inset(EdgeInsetsMake(15, left: 20, bottom: 0, right: 20))
        }
    }
    
}

class EventScrollView: UIScrollView {
    
    var topInset: Float = 0
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return Float(point.y) + topInset > topInset
    }
    
}

private extension UILabel {
    static func titleLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.titleBoldFontOfSize(35)
        
        return label
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