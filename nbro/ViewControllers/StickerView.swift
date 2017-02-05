//
//  StickerView.swift
//  nbro
//
//  Created by Peter Gammelgaard Poulsen on 04/02/2017.
//  Copyright © 2017 Bob. All rights reserved.
//

import Foundation
import SVGKit

class StickerView: UIView {
    let imageView: UIView
    fileprivate let boundingRect: CGRect
    fileprivate var rotated: CGFloat = 0
    fileprivate var scale: CGFloat = 1
    
    init(view: UIView, boundTo: CGRect) {
        imageView = view
        boundingRect = boundTo
        
        super.init(frame: .zero)
        
        setupSubviews()
        setupGestures()
        
        DispatchQueue.main.async {
            self.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    private func setupGestures() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:)))
        pan.delegate = self
        pan.maximumNumberOfTouches = 1
        addGestureRecognizer(pan)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinch(gesture:)))
        pinch.delegate = self
        addGestureRecognizer(pinch)
        
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(rotate(gesture:)))
        rotation.delegate = self
        addGestureRecognizer(rotation)
    }
}

extension StickerView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

fileprivate extension StickerView {
    dynamic fileprivate func pan(gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        let translate = gesture.translation(in: self)
        
        if gesture.state == .changed {
            view.transform = view.transform.translatedBy(x: translate.x, y: translate.y)
            gesture.setTranslation(CGPoint.zero, in: self)
        }
    }
    
    dynamic fileprivate func pinch(gesture: UIPinchGestureRecognizer) {
        guard let view = gesture.view else { return }
        if gesture.state == .began {
            self.scale = gesture.scale
        }
        
        if gesture.state == .began || gesture.state == .changed {
            let current = view.layer.value(forKeyPath: "transform.scale") as! CGFloat
            let maximum: CGFloat = 1.5
            let minimum: CGFloat = 0.3
            let new: CGFloat = max(min(1 - (scale - gesture.scale), maximum / current), minimum / current)
            view.transform = view.transform.scaledBy(x: new, y: new)
            scale = gesture.scale
        }
    }
    
    dynamic fileprivate func rotate(gesture: UIRotationGestureRecognizer) {
        guard let view = gesture.view else { return }
        
        view.transform = view.transform.rotated(by: gesture.rotation)
        rotated += gesture.rotation
        gesture.rotation = 0
    }
}
