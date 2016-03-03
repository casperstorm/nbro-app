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
    private let backgroundImageView = UIImageView(image: UIImage(named: "slider_bg")!.resizableImageWithCapInsets(UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30)))
    private let knobImageView = UIImageView(image: UIImage(named: "slider_man"))
    private let knobContainerView = KnobContainerView()
    private let panGestureRecognizer = UIPanGestureRecognizer()
    private var knobOffset: CGFloat = 0
    private let shimmeringView = FBShimmeringView()
    var isLeft = true {
        didSet {
            knobOffset = self.isLeft ? knobInset : bounds.width - knobInset - (bounds.height - 2 * knobInset)
            setNeedsUpdateConstraints()
            setupText()
        }
    }
    private let containerView = UIView()
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
        
        containerView.clipsToBounds = true
        setupText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupText() {
        titleLabel.alpha = 0.0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        
        if self.isLeft {
            let text = NSMutableAttributedString(string: "SLIDE TO ATTEND RUN")
            text.addAttributes([
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName: UIFont.defaultBoldFontOfSize(14),
                NSForegroundColorAttributeName: UIColor.blackColor()
                ], range: NSMakeRange(0, 8))
            text.addAttributes([
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName: UIFont.defaultRegularFontOfSize(14),
                NSForegroundColorAttributeName: UIColor.blackColor()
                ], range: NSMakeRange(8, 11))
            self.titleLabel.attributedText = text
        } else {
            let text = NSMutableAttributedString(string: "YAY! SEE YOU THERE.")
            text.addAttributes([
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName: UIFont.defaultBoldFontOfSize(14),
                NSForegroundColorAttributeName: UIColor.blackColor()
                ], range: NSMakeRange(0, 3))
            text.addAttributes([
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName: UIFont.defaultRegularFontOfSize(14),
                NSForegroundColorAttributeName: UIColor.blackColor()
                ], range: NSMakeRange(3, 15))
            self.titleLabel.attributedText = text
            
        }
        
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
        
        UIView.animateWithDuration(0.3) { () -> Void in
            self.titleLabel.alpha = 1.0
        }
    }
    
    private func setupSubviews() {
        shimmeringView.contentView = titleLabel
        containerView.addSubview(shimmeringView)
        let subviews = [backgroundImageView, containerView, knobContainerView]
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
        containerView.snp_updateConstraints { (make) -> Void in
            make.top.bottom.equalTo(containerView.superview!)
            make.right.equalTo(containerView.superview!).offset(isLeft ? 0 : -(self.frame.width - knobOffset - (knobImageView.frame.width / 2.0)) )
            make.left.equalTo(containerView.superview!).offset(isLeft ? knobOffset + knobImageView.frame.width / 2.0 : 0)
        }
        
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
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        return knobContainerView.pointInside(point, withEvent: event) ? knobContainerView : nil
    }
}

private class KnobContainerView: UIView {
    
    private override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        let center = self.center
        let distance = abs(hypotf(Float(center.x - point.x), Float(center.y - point.y)))
        return distance < Float(60)
    }
}

private extension UILabel {
    static func titleLabel() -> UILabel {
        let label = UILabel()
        
        return label
    }
}