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
    let facebookButton = UIButton.facebookButton()
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
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let subviews = [mapView, mapOverlay, cancelButton, scrollView, facebookButton]
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
            make.top.leading.equalTo(cancelButton.superview!).inset(EdgeInsetsMake(20, left: 5, bottom: 0, right: 0))
            make.width.height.equalTo(40)
        }
        
        facebookButton.snp_makeConstraints { (make) -> Void in
            make.top.trailing.equalTo(facebookButton.superview!).inset(EdgeInsetsMake(20, left: 0, bottom: 0, right: 5))
            make.width.height.equalTo(40)
        }
    }
}

class EventView: UIView {
    
    let titleLabel = UILabel.titleLabel()
    let dateLabel = UILabel.dateLabel()
    let titleSeparator = EventSeparator()
    let descriptionSeparator = EventSeparator()

    let timeDetailView = DetailLabelView()
    let locationDetailView = DetailLabelView()
    let descriptionLabel = UILabel.descriptionLabel()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .whiteColor()
        setupSubviews()
        defineLayout()
        
        layer.cornerRadius = 6
        layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let subviews = [titleLabel, dateLabel, titleSeparator, descriptionLabel, timeDetailView, locationDetailView, descriptionSeparator]
        subviews.forEach { addSubview($0) }
    }
    
    private func defineLayout() {
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.leading.trailing.top.equalTo(titleLabel.superview!).inset(EdgeInsetsMake(25, left: 25, bottom: 0, right: 25))
        }
        
        dateLabel.snp_makeConstraints { (make) -> Void in
            make.leading.trailing.equalTo(dateLabel.superview!).inset(EdgeInsetsMake(0, left: 25, bottom: 0, right: 25))
            make.top.equalTo(titleLabel.snp_bottom).offset(5)
        }
        
        titleSeparator.snp_makeConstraints { (make) -> Void in
            make.leading.trailingMargin.equalTo(titleSeparator.superview!)
            make.top.equalTo(dateLabel.snp_bottom).offset(15)
        }
        
        timeDetailView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(timeDetailView.superview!).offset(30)
            make.top.equalTo(titleSeparator.snp_bottom).offset(15)
        }
        
        locationDetailView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(timeDetailView.snp_trailing)
            make.trailing.equalTo(locationDetailView.superview!).offset(-30)
            make.height.width.top.equalTo(timeDetailView)
        }
        
        descriptionSeparator.snp_makeConstraints { (make) -> Void in
            make.leading.trailingMargin.equalTo(descriptionSeparator.superview!)
            make.top.equalTo(locationDetailView.snp_bottom).offset(15)
        }
        
        descriptionLabel.snp_makeConstraints { (make) -> Void in
            make.leading.trailingMargin.equalTo(descriptionLabel.superview!).inset(EdgeInsets(top: 0, left: 25, bottom: 0, right: 25))
            make.top.equalTo(descriptionSeparator.snp_bottom).offset(15)
            make.bottom.lessThanOrEqualTo(descriptionLabel.superview!).offset(-25)
        }
    }
    
    class EventSeparator: UIView {
        private class Circle: UIView {
            init(cornerRadius: CGFloat) {
                super.init(frame: CGRect.zero)
                
                backgroundColor = .blackColor()
                layer.cornerRadius = cornerRadius
                layer.masksToBounds = true
                snp_makeConstraints { (make) -> Void in
                    make.height.width.equalTo(2 * cornerRadius)
                }
            }
            
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
        }
        
        private let leftCircle = Circle(cornerRadius: 5)
        private let rightCircle = Circle(cornerRadius: 5)
        private let line: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1.0)
            
            return view
        }()
        
        init() {
            super.init(frame: CGRect.zero)
            
            setupSubviews()
            defineLayout()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupSubviews() {
            let subviews = [leftCircle, rightCircle, line]
            subviews.forEach { addSubview($0) }
        }
        
        private func defineLayout() {
            leftCircle.snp_makeConstraints { (make) -> Void in
                make.centerX.equalTo(leftCircle.superview!.snp_leading)
                make.top.bottom.equalTo(leftCircle.superview!)
            }
            
            line.snp_makeConstraints { (make) -> Void in
                make.centerY.leading.trailing.equalTo(line.superview!).inset(EdgeInsets(top: 0, left: 25, bottom: 0, right: 25))
                make.height.equalTo(1)
            }
            
            rightCircle.snp_makeConstraints { (make) -> Void in
                make.centerX.equalTo(rightCircle.superview!.snp_trailing)
                make.top.bottom.equalTo(rightCircle.superview!)
            }
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
        label.font = UIFont.titleBoldFontOfSize(40)
        label.numberOfLines = 2
        
        return label
    }
    
    static func dateLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.defaultSemiBoldFontOfSize(14)
        label.textColor = UIColor(red: 115/255.0, green: 115/255.0, blue: 115/255.0, alpha: 1.0)
        
        return label
    }
    
    static func descriptionLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.defaultLightFontOfSize(13)
        label.textColor = UIColor(hex: 0x090909)
        
        return label
    }
}

private extension UIButton {
    static func cancelButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_cancel"), forState: .Normal)
        
        return button
    }
    
    static func facebookButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "about_facebook_icon"), forState: .Normal)
        
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