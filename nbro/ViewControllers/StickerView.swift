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
    let sticker: Sticker
    fileprivate let boundingRect: CGRect
    fileprivate var rotated: CGFloat = 0
    fileprivate var scale: CGFloat = 1
    
    init(sticker: Sticker, boundTo: CGRect) {
        self.sticker = sticker
        imageView = SVGKFastImageView(svgkImage: sticker.image)
        boundingRect = boundTo
        
        super.init(frame: .zero)
        
        setupSubviews()        
        DispatchQueue.main.async {
//            self.transform = CGAffineTransform(scaleX: 0.35, y: 0.35)
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
}

extension StickerView {
    dynamic func pan(gesture: UIPanGestureRecognizer) {
        let view = self
        let translate = gesture.translation(in: self)
        
        if gesture.state == .changed {
            view.transform = view.transform.translatedBy(x: translate.x, y: translate.y)
            
            sticker.transform = view.transform
            sticker.position = CGPoint(x: sticker.position.x + (translate.x * CGFloat(sticker.scale)), y: sticker.position.y + (translate.y * CGFloat(sticker.scale)))
            print("\(sticker.position)")
            gesture.setTranslation(CGPoint.zero, in: self)
        }
    }
    
    dynamic func pinch(gesture: UIPinchGestureRecognizer) {
        let view = self
        if gesture.state == .began {
            self.scale = gesture.scale
        }
        
        if gesture.state == .began || gesture.state == .changed {
            let current = view.layer.value(forKeyPath: "transform.scale") as! CGFloat
            let maximum: CGFloat = 1.0
            let minimum: CGFloat = 0.4
            let new: CGFloat = max(min(1 - (scale - gesture.scale), maximum / current), minimum / current)
            view.transform = view.transform.scaledBy(x: new, y: new)
            scale = scale * new
            
            sticker.transform = view.transform
            sticker.scale = sticker.scale * Float(new)
        }
    }
    
    dynamic func rotate(gesture: UIRotationGestureRecognizer) {
        let view = self
        
        view.transform = view.transform.rotated(by: gesture.rotation)
        rotated += gesture.rotation
        gesture.rotation = 0
        
        sticker.rotation = Float(rotated)
        sticker.transform = view.transform
    }
}
