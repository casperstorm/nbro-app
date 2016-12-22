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
    fileprivate let scrollView = EventScrollView()
    let eventView = EventView()
    let panGestureRecognizer = UIPanGestureRecognizer()
    let topInset: CGFloat

    init() {
        let screenHeight = UIScreen.main.bounds.height
        self.topInset = screenHeight * 0.32
        super.init(frame: CGRect.zero)
        backgroundColor = .black
        setupSubviews()
        defineLayout()
        
        
        scrollView.topInset = Float(topInset)
        scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        mapView.delegate = self
        
        bottomView.backgroundColor = .black
        panGestureRecognizer.delegate = self
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let point = gestureRecognizer.location(in: gestureRecognizer.view)
        let offset = scrollView.contentOffset.y + topInset
        if point.y + offset <= topInset {
            return true
        } else {
            return Int(scrollView.contentOffset.y) <= Int(-topInset)
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        
        let velocity = panGestureRecognizer.velocity(in: gestureRecognizer.view)
        
        return velocity.y > 0.0
    }
    
    func addAnnotationAtCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        return MGLAnnotationImage(image: UIImage(named: "pin")!, reuseIdentifier: "Pin")
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        addGestureRecognizer(panGestureRecognizer)
        let subviews = [mapView, mapOverlay, bottomView, mapBoxImageView, cancelButton, scrollView, facebookButton]
        subviews.forEach { addSubview($0) }
        
        scrollView.addSubview(eventView)
    }
    
    fileprivate func defineLayout() {
        let screenHeight = UIScreen.main.bounds.height

        mapView.snp.makeConstraints { (make) -> Void in
            make.top.leading.trailing.equalTo(mapView.superview!)
            make.height.equalTo(screenHeight).multipliedBy(1.0)
        }
        
        mapOverlay.snp.makeConstraints { (make) -> Void in
            make.top.leading.trailing.equalTo(mapOverlay.superview!)
            make.height.equalTo(screenHeight * 0.35)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(mapOverlay.snp.bottom)
            make.leading.trailing.bottom.equalTo(bottomView.superview!)
        }
        
        scrollView.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.top.bottom.equalTo(scrollView.superview!).inset(EdgeInsetsMake(0, left: 7, bottom: 0, right: 7))
        }
        
        eventView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(eventView.superview!).inset(EdgeInsetsMake(0, left: 0, bottom: 7, right: 0))
            make.width.equalTo(eventView.superview!)
            make.height.greaterThanOrEqualTo(screenHeight * 0.67)
        }
        
        cancelButton.snp.makeConstraints { (make) -> Void in
            make.top.leading.equalTo(cancelButton.superview!).inset(EdgeInsetsMake(20, left: 5, bottom: 0, right: 0))
            make.width.height.equalTo(40)
        }
        
        facebookButton.snp.makeConstraints { (make) -> Void in
            make.top.trailing.equalTo(facebookButton.superview!).inset(EdgeInsetsMake(20, left: 0, bottom: 0, right: 5))
            make.width.height.equalTo(40)
        }
        
        mapBoxImageView.snp.makeConstraints { (make) in
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
    let attendingDetailView = DetailLabelView()
    let interestedDetailView = DetailLabelView()
    let descriptionLabel = UILabel.descriptionLabel()
    let attendeesButton = UIButton.invisibleButton()
    let interestedButton = UIButton.invisibleButton()
    let soundPlayer: AVAudioPlayer = {
        let soundURL = Bundle.main.url(forResource: "pop", withExtension: "aiff")
        let data = try? Data(contentsOf: soundURL!)
        let player = try! AVAudioPlayer(data: data!)
        player.prepareToPlay()
        
        return player
    }()

    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .white
        attendSeparator.showDots = false
        verticalSeparator.backgroundColor = UIColor(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1.0)
        setupSubviews()
        defineLayout()
        
        layer.cornerRadius = 6
        layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        let subviews = [titleLabel, dateLabel, titleSeparator, descriptionLabel, attendingDetailView, interestedDetailView, descriptionSeparator, attendSeparator, verticalSeparator, attentButtonView, confettiView, attendeesButton, interestedButton]
        subviews.forEach { addSubview($0) }
    }
    
    fileprivate func defineLayout() {
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.top.equalTo(titleLabel.superview!).inset(EdgeInsetsMake(25, left: 25, bottom: 0, right: 25))
        }
        
        dateLabel.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.equalTo(dateLabel.superview!).inset(EdgeInsetsMake(0, left: 25, bottom: 0, right: 25))
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        titleSeparator.snp.makeConstraints { (make) -> Void in
            make.leading.trailingMargin.equalTo(titleSeparator.superview!)
            make.top.equalTo(dateLabel.snp.bottom).offset(15)
        }
        
        attendingDetailView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(attendingDetailView.superview!).offset(40)
            make.top.equalTo(titleSeparator.snp.bottom).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(60)
        }
        
        attendeesButton.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(verticalSeparator.snp.left)
            make.top.equalTo(titleSeparator.snp.bottom)
            make.bottom.equalTo(descriptionSeparator.snp.top)
        }
        
        interestedButton.snp.makeConstraints { (make) in
            make.right.equalTo(self)
            make.left.equalTo(verticalSeparator.snp.right)
            make.top.equalTo(titleSeparator.snp.bottom)
            make.bottom.equalTo(descriptionSeparator.snp.top)
        }
        
        verticalSeparator.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(titleSeparator.snp.bottom)
            make.width.equalTo(1)
            make.bottom.equalTo(descriptionSeparator.snp.top)
        }
        
        interestedDetailView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(verticalSeparator.snp.trailing).offset(20)
            make.trailing.equalTo(interestedDetailView.superview!).offset(-25)
            make.height.top.equalTo(attendingDetailView)
        }
        
        descriptionSeparator.snp.makeConstraints { (make) -> Void in
            make.leading.trailingMargin.equalTo(descriptionSeparator.superview!)
            make.top.equalTo(interestedDetailView.snp.bottom).offset(10)
        }

        attentButtonView.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionSeparator.snp.bottom).offset(15)
            make.leading.trailingMargin.equalTo(attentButtonView.superview!).inset(EdgeInsets(top: 0, left: 25, bottom: 0, right: 25))
        }
        
        attendSeparator.snp.makeConstraints { (make) -> Void in
            make.leading.trailingMargin.equalTo(attendSeparator.superview!)
            make.top.equalTo(attentButtonView.snp.bottom).offset(10)
        }
        
        descriptionLabel.snp.makeConstraints { (make) -> Void in
            make.leading.trailingMargin.equalTo(descriptionLabel.superview!).inset(EdgeInsets(top: 0, left: 25, bottom: 0, right: 25))
            make.top.equalTo(attendSeparator.snp.bottom).offset(15)
            make.bottom.lessThanOrEqualTo(descriptionLabel.superview!).offset(-25)
        }
        
        confettiView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(attentButtonView)
            make.height.equalTo(self)
        }
    }
    
    func descriptionTextWithAjustedLineHeight(_ text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4.0
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        descriptionLabel.attributedText = attrString
    }
    
    func fireConfetti() {
        soundPlayer.currentTime = 0
        soundPlayer.play()
        
        confettiView.blast(from: CGPoint(x: 150, y: 25), towards: CGFloat(M_PI)/2, withForce: 500, confettiWidth: 8, numberOfConfetti: 40)
        confettiView.blast(from: CGPoint(x: 150, y: 25), towards: CGFloat(M_PI)/2, withForce: 500, confettiWidth: 3, numberOfConfetti: 20)
    }
    
    class EventSeparator: UIView {
        fileprivate class Circle: UIView {
            init(cornerRadius: CGFloat) {
                super.init(frame: CGRect.zero)
                
                backgroundColor = .black
                layer.cornerRadius = cornerRadius
                layer.masksToBounds = true
                snp.makeConstraints { (make) -> Void in
                    make.height.width.equalTo(2 * cornerRadius)
                }
            }
            
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
        }
        
        fileprivate let leftCircle = Circle(cornerRadius: 5)
        fileprivate let rightCircle = Circle(cornerRadius: 5)
        
        var showDots: Bool = true {
            didSet {
                leftCircle.isHidden = !self.showDots
                rightCircle.isHidden = !self.showDots
            }
        }
        fileprivate let line: UIView = {
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
        
        fileprivate func setupSubviews() {
            let subviews = [leftCircle, rightCircle, line]
            subviews.forEach { addSubview($0) }
        }
        
        fileprivate func defineLayout() {
            leftCircle.snp.makeConstraints { (make) -> Void in
                make.centerX.equalTo(leftCircle.superview!.snp.leading).offset(-1)
                make.top.bottom.equalTo(leftCircle.superview!)
            }
            
            line.snp.makeConstraints { (make) -> Void in
                make.centerY.leading.trailing.equalTo(line.superview!).inset(EdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
                make.height.equalTo(1)
            }
            
            rightCircle.snp.makeConstraints { (make) -> Void in
                make.centerX.equalTo(rightCircle.superview!.snp.trailing).offset(1)
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
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
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
        button.setImage(UIImage(named: "icon_cancel"), for: UIControlState())
        
        return button
    }
    
    static func facebookButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "detail_facebook_icon"), for: UIControlState())
        
        return button
    }
    
    static func invisibleButton() -> UIButton {
        return UIButton()
    }
}

private extension MGLMapView {
    static func eventMapView() -> MGLMapView {
        // There is a bug where it needs a frame in init https://github.com/mapbox/mapbox-gl-native/issues/1572
        let frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        let mapView = MGLMapView(frame: frame, styleURL: MGLStyle.darkStyleURL())
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isRotateEnabled = false
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.attributionButton.isHidden = true
        
        return mapView
    }
}

private extension L360ConfettiArea {
    static func confettiArea() -> L360ConfettiArea {
        let confettiArea = L360ConfettiArea()
        confettiArea.swayLength = 20.0
        confettiArea.isUserInteractionEnabled = false
        confettiArea.blastSpread = 0.4
        return confettiArea
    }
}
