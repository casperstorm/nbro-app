//
//  SwipeView.swift
//  Oddset
//
//  Created by Peter Gammelgaard Poulsen on 01/03/16.
//  Copyright © 2016 Shape. All rights reserved.
//


import Foundation
import UIKit
import SnapKit
import Shimmer

class SwitchView: UIView, UIGestureRecognizerDelegate {
    private let backgroundImageView = UIImageView(image: UIImage(named: "slider_bg")!.resizableImageWithCapInsets(UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)))
    private let knobImageView = UIImageView(image: UIImage(named: "slider_man"))
    private let knobContainerView = KnobContainerView()
    private let panGestureRecognizer = UIPanGestureRecognizer()
    private var knobOffset: CGFloat = 5
    private let shimmeringView = FBShimmeringView()
    var isLeft = true
    let titleLabel = UILabel.titleLabel()
    
    var knobInset: CGFloat = 0
    var backgroundImage: UIImage? {
        didSet {
            backgroundImageView.image = backgroundImage
        }
    }
    var knobImage: UIImage? {
        didSet {
            knobImageView.image = knobImage
        }
    }
    
    var didSwipe: (Bool -> Void)?
    
    init() {
        super.init(frame: CGRect.zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        panGestureRecognizer.delegate = self
        panGestureRecognizer.minimumNumberOfTouches = 1
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.addTarget(self, action: "viewDidPan:")
        knobContainerView.addGestureRecognizer(panGestureRecognizer)
        
        setupSubviews()
        defineLayout()
        
        shimmeringView.shimmeringHighlightLength = 0.5
        shimmeringView.shimmeringSpeed = 150
        shimmeringView.shimmering = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        shimmeringView.contentView = titleLabel
        let subviews = [backgroundImageView, shimmeringView, knobContainerView]
        subviews.forEach { addSubview($0) }
        
        knobContainerView.addSubview(knobImageView)
    }
    
    private func defineLayout() {
        backgroundImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(self).inset(1)
        }
        
        shimmeringView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.top.bottom.equalTo(titleLabel.superview!)
            make.centerX.equalTo(self)
        }
        
        knobImageView.snp_updateConstraints { (make) in
            make.center.equalTo(knobImageView.superview!)
        }
    }
    
    override func updateConstraints() {
        knobContainerView.snp_updateConstraints { (make) in
            make.top.bottom.equalTo(knobContainerView.superview!)
            make.left.equalTo(knobContainerView.superview!).offset(knobOffset)
            make.width.equalTo(knobContainerView.snp_height)
            
        }
        
        super.updateConstraints()
    }
    
    dynamic private func viewDidPan(panGestureRecognizer: UIPanGestureRecognizer) {
        var translation = panGestureRecognizer.translationInView(panGestureRecognizer.view?.superview!)
        
        if panGestureRecognizer.state == .Began {
            let point = panGestureRecognizer.locationInView(self)
            translation.x += (point.x - knobContainerView.frame.width)
        }
        panGestureRecognizer.locationInView(self)
        
        let offset = knobOffset + translation.x
        let offsetMin = max(offset, knobInset)
        let offsetMax = min(offset, bounds.width - knobInset - (bounds.height - 2 * knobInset))
        
        knobOffset = offset < knobInset ? offsetMin : offsetMax
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
        
        panGestureRecognizer.setTranslation(CGPoint.zero, inView: panGestureRecognizer.view?.superview!)
        
        
        if panGestureRecognizer.state == .Ended {
            if isLeft {
                if knobOffset == bounds.width - knobInset - (bounds.height - 2 * knobInset) {
                    isLeft = false
                    didSwipe?(isLeft)
                } else {
                    knobOffset = knobInset
                        setNeedsUpdateConstraints()
                    setNeedsLayout()
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.layoutIfNeeded()
                    })
                }
            } else {
                if knobOffset == knobInset {
                    isLeft = true
                    didSwipe?(isLeft)
                } else {
                    knobOffset = bounds.width - knobInset - (bounds.height - 2 * knobInset)
                    setNeedsUpdateConstraints()
                    setNeedsLayout()
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.layoutIfNeeded()
                    })
                }
            }
        }
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let convertedPoint = self.convertPoint(point, toView: knobContainerView)
        return knobContainerView.pointInside(convertedPoint, withEvent: event) ? knobContainerView : nil
    }
}

private class KnobContainerView: UIView {
    
    private override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        let center = self.center
        let distance = abs(hypotf(Float(center.x - point.x), Float(center.y - point.y)))
        return distance < Float(40)
    }
}

private extension UILabel {
    static func titleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor(hex: 0xFFB369)
        label.textAlignment = .Center
        
        return label
    }
}