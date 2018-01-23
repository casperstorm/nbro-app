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
    let imageView: SVGKFastImageView
    let sticker: StickerModel
    fileprivate let boundingRect: CGRect
    fileprivate var rotated: CGFloat = 0
    fileprivate var scale: CGFloat = 1
    
    init(sticker: StickerModel, boundTo: CGRect) {
        self.sticker = sticker
        imageView = SVGKFastImageView(svgkImage: sticker.sticker.currentSVG)
        boundingRect = boundTo
        
        super.init(frame: .zero)
        
        setupSubviews()        
        DispatchQueue.main.async {
            let startScale: Float = 0.35
            self.transform = CGAffineTransform(scaleX: CGFloat(startScale), y: CGFloat(startScale))
            self.sticker.scale = startScale
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
    @objc dynamic func pan(gesture: UIPanGestureRecognizer) {
        let view = self
        let translate = gesture.translation(in: self)
        
        if gesture.state == .changed {
            
            view.transform = view.transform.translatedBy(x: translate.x, y: translate.y)
            let rotated = translate.applying(CGAffineTransform(rotationAngle: self.rotated))
            sticker.transform = view.transform
            sticker.position = CGPoint(x: sticker.position.x + (rotated.x * CGFloat(sticker.scale)), y: sticker.position.y + (rotated.y * CGFloat(sticker.scale)))
            gesture.setTranslation(CGPoint.zero, in: self)
        }
    }
    
    @objc dynamic func pinch(gesture: UIPinchGestureRecognizer) {
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
    
    @objc dynamic func rotate(gesture: UIRotationGestureRecognizer) {
        let view = self
        
        view.transform = view.transform.rotated(by: gesture.rotation)
        rotated += gesture.rotation
        gesture.rotation = 0
        
        sticker.rotation = Float(rotated)
        sticker.transform = view.transform
    }
    
    @objc dynamic func doubleTap(gesture: UITapGestureRecognizer) {
        sticker.sticker.invert()
        imageView.image = sticker.sticker.currentSVG
    }
}
