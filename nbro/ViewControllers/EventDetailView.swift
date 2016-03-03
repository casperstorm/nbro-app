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
import L360Confetti
import AVFoundation
class EventDetailView: UIView, MGLMapViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate {
 
    let cancelButton = UIButton.cancelButton()
    let facebookButton = UIButton.facebookButton()
    let mapView = MGLMapView.eventMapView()
    let mapOverlay = UIImageView(image: UIImage(named: "map_overlay"))
    let bottomView = UIView()
    let mapBoxImageView = UIImageView.mapBoxImageView()
    private let scrollView = EventScrollView()
    let eventView = EventView()
    let panGestureRecognizer = UIPanGestureRecognizer()
    let topInset: CGFloat

    init() {
        let screenHeight = UIScreen.mainScreen().bounds.height
        self.topInset = screenHeight * 0.32
        super.init(frame: CGRect.zero)
        backgroundColor = .blackColor()
        setupSubviews()
        defineLayout()
        
        
        scrollView.topInset = Float(topInset)
        scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        mapView.delegate = self
        
        bottomView.backgroundColor = .blackColor()
        panGestureRecognizer.delegate = self
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let point = gestureRecognizer.locationInView(gestureRecognizer.view)
        let offset = scrollView.contentOffset.y + topInset
        if point.y + offset <= topInset {
            return true
        } else {
            return Int(scrollView.contentOffset.y) <= Int(-topInset)
        }
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        
        let velocity = panGestureRecognizer.velocityInView(gestureRecognizer.view)
        
        return velocity.y > 0.0
    }
    
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D) {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        return MGLAnnotationImage(image: UIImage(named: "pin")!, reuseIdentifier: "Pin")
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addGestureRecognizer(panGestureRecognizer)
        let subviews = [mapView, mapOverlay, bottomView, mapBoxImageView, cancelButton, scrollView, facebookButton]
        subviews.forEach { addSubview($0) }
        
        scrollView.addSubview(eventView)
    }
    
    private func defineLayout() {
        let screenHeight = UIScreen.mainScreen().bounds.height

        mapView.snp_makeConstraints { (make) -> Void in
            make.top.leading.trailing.equalTo(mapView.superview!)
            make.height.equalTo(screenHeight).multipliedBy(1.0)
        }
        
        mapOverlay.snp_makeConstraints { (make) -> Void in
            make.top.leading.trailing.equalTo(mapOverlay.superview!)
            make.height.equalTo(screenHeight * 0.35)
        }
        
        bottomView.snp_makeConstraints { (make) in
            make.top.equalTo(mapOverlay.snp_bottom)
            make.leading.trailing.bottom.equalTo(bottomView.superview!)
        }
        
        scrollView.snp_makeConstraints { (make) -> Void in
            make.leading.trailing.top.bottom.equalTo(scrollView.superview!).inset(EdgeInsetsMake(0, left: 7, bottom: 0, right: 7))
        }
        
        eventView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(eventView.superview!).inset(EdgeInsetsMake(0, left: 0, bottom: 7, right: 0))
            make.width.equalTo(eventView.superview!)
            make.height.greaterThanOrEqualTo(screenHeight * 0.67)
        }
        
        cancelButton.snp_makeConstraints { (make) -> Void in
            make.top.leading.equalTo(cancelButton.superview!).inset(EdgeInsetsMake(20, left: 5, bottom: 0, right: 0))
            make.width.height.equalTo(40)
        }
        
        facebookButton.snp_makeConstraints { (make) -> Void in
            make.top.trailing.equalTo(facebookButton.superview!).inset(EdgeInsetsMake(20, left: 0, bottom: 0, right: 5))
            make.width.height.equalTo(40)
        }
        
        mapBoxImageView.snp_makeConstraints { (make) in
            make.bottom.left.equalTo(mapBoxImageView.superview!).inset(16)
        }
    }
}

class EventView: UIView {
    
    let titleLabel = UILabel.titleLabel()
    let dateLabel = UILabel.dateLabel()
    let titleSeparator = EventSeparator()
    let descriptionSeparator = EventSeparator()
    let verticalSeparator = UIView()
    let attentButtonView = AttentEventButtonView()
    let attendSeparator = EventSeparator()
    let confettiView = L360ConfettiArea.confettiArea()
    
    let timeDetailView = DetailLabelView()
    let locationDetailView = DetailLabelView()
    let descriptionLabel = UILabel.descriptionLabel()
    private var sound: SystemSoundID = 0

    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .whiteColor()
        attendSeparator.showDots = false
        verticalSeparator.backgroundColor = UIColor(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1.0)
        setupSubviews()
        defineLayout()
        
        layer.cornerRadius = 6
        layer.masksToBounds = true
        
        if let soundURL = NSBundle.mainBundle().URLForResource("pop", withExtension: "aiff") {
            AudioServicesCreateSystemSoundID(soundURL, &sound)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let subviews = [titleLabel, dateLabel, titleSeparator, descriptionLabel, timeDetailView, locationDetailView, descriptionSeparator, attendSeparator, verticalSeparator, attentButtonView, confettiView]
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
            make.leading.equalTo(timeDetailView.superview!).offset(40)
            make.top.equalTo(titleSeparator.snp_bottom).offset(10)
            make.width.equalTo(50)
        }
        
        verticalSeparator.snp_makeConstraints { (make) in
            make.leading.equalTo(timeDetailView.snp_trailing).offset(20)
            make.top.equalTo(titleSeparator.snp_bottom)
            make.width.equalTo(1)
            make.bottom.equalTo(descriptionSeparator.snp_top)
        }
        
        locationDetailView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(verticalSeparator.snp_trailing).offset(20)
            make.trailing.equalTo(locationDetailView.superview!).offset(-25)
            make.height.top.equalTo(timeDetailView)
        }
        
        descriptionSeparator.snp_makeConstraints { (make) -> Void in
            make.leading.trailingMargin.equalTo(descriptionSeparator.superview!)
            make.top.equalTo(locationDetailView.snp_bottom).offset(10)
        }
        
        attentButtonView.snp_makeConstraints { (make) in
            make.top.equalTo(descriptionSeparator.snp_bottom).offset(15)
            make.leading.trailingMargin.equalTo(attentButtonView.superview!).inset(EdgeInsets(top: 0, left: 25, bottom: 0, right: 25))
        }
        
        attendSeparator.snp_makeConstraints { (make) -> Void in
            make.leading.trailingMargin.equalTo(attendSeparator.superview!)
            make.top.equalTo(attentButtonView.snp_bottom).offset(10)
        }
        
        descriptionLabel.snp_makeConstraints { (make) -> Void in
            make.leading.trailingMargin.equalTo(descriptionLabel.superview!).inset(EdgeInsets(top: 0, left: 25, bottom: 0, right: 25))
            make.top.equalTo(attendSeparator.snp_bottom).offset(15)
            make.bottom.lessThanOrEqualTo(descriptionLabel.superview!).offset(-25)
        }
        
        confettiView.snp_makeConstraints { (make) in
            make.left.top.right.equalTo(attentButtonView)
            make.height.equalTo(self)
        }
    }
    
    func descriptionTextWithAjustedLineHeight(text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4.0
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        descriptionLabel.attributedText = attrString
    }
    
    func fireConfetti() {
//        if let soundURL = NSBundle.mainBundle().URLForResource("pop", withExtension: "aiff") {
//            var mySound: SystemSoundID = 0
//            AudioServicesCreateSystemSoundID(soundURL, &mySound)
//            AudioServicesPlaySystemSound(mySound);
//        }
        
        AudioServicesPlaySystemSound(sound);

        
        confettiView.blastFrom(CGPointMake(150, 25), towards: CGFloat(M_PI)/2, withForce: 500, confettiWidth: 8, numberOfConfetti: 40)
        confettiView.blastFrom(CGPointMake(150, 25), towards: CGFloat(M_PI)/2, withForce: 500, confettiWidth: 3, numberOfConfetti: 20)
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
        
        var showDots: Bool = true {
            didSet {
                leftCircle.hidden = !self.showDots
                rightCircle.hidden = !self.showDots
            }
        }
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
                make.centerX.equalTo(leftCircle.superview!.snp_leading).offset(-1)
                make.top.bottom.equalTo(leftCircle.superview!)
            }
            
            line.snp_makeConstraints { (make) -> Void in
                make.centerY.leading.trailing.equalTo(line.superview!).inset(EdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
                make.height.equalTo(1)
            }
            
            rightCircle.snp_makeConstraints { (make) -> Void in
                make.centerX.equalTo(rightCircle.superview!.snp_trailing).offset(1)
                make.top.bottom.equalTo(rightCircle.superview!)
            }
        }
        
    }
    
}

private extension UIImageView {
    static func mapBoxImageView() -> UIImageView {
        return UIImageView(image: UIImage(named: "map_box_logo"))
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
        label.font = UIFont.defaultLightFontOfSize(16)
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
        button.setImage(UIImage(named: "detail_facebook_icon"), forState: .Normal)
        
        return button
    }
}

private extension MGLMapView {
    static func eventMapView() -> MGLMapView {
        // There is a bug where it needs a frame in init https://github.com/mapbox/mapbox-gl-native/issues/1572
        let frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        let mapView = MGLMapView(frame: frame, styleURL: MGLStyle.darkStyleURL())
        mapView.zoomEnabled = false
        mapView.scrollEnabled = false
        mapView.rotateEnabled = false
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        mapView.attributionButton.hidden = true
        
        return mapView
    }
}

private extension L360ConfettiArea {
    static func confettiArea() -> L360ConfettiArea {
        let confettiArea = L360ConfettiArea()
        confettiArea.swayLength = 20.0
        confettiArea.userInteractionEnabled = false
        confettiArea.blastSpread = 0.4
        return confettiArea
    }
}
