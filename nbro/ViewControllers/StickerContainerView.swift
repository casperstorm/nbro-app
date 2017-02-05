//
//  StickerContainerView.swift
//  nbro
//
//  Created by Peter Gammelgaard Poulsen on 04/02/2017.
//  Copyright © 2017 Bob. All rights reserved.
//

import Foundation
import SVGKit

class StickerContainerView: UIView {
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .yellow
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "background_image.jpg")
        
        return imageView
    }()
    
    fileprivate var stickers = [StickerView]()
    fileprivate var selectedSticker: StickerView?
    
    init() {
        super.init(frame: .zero)
        
        setupSubviews()
        defineLayout()
        setupGestures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(imageView)
    }
    
    private func defineLayout() {
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(imageView.superview!)
        }
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

extension StickerContainerView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.stickerView(for: gestureRecognizer) != nil
    }
}

fileprivate extension StickerContainerView {
    dynamic func pan(gesture: UIPanGestureRecognizer) {
        guard let stickerView = self.stickerView(for: gesture) else { return }
        stickerView.pan(gesture: gesture)
    }
    
    dynamic func pinch(gesture: UIPinchGestureRecognizer) {
        guard let stickerView = self.stickerView(for: gesture) else { return }
        stickerView.pinch(gesture: gesture)
    }
    
    dynamic func rotate(gesture: UIRotationGestureRecognizer) {
        guard let stickerView = self.stickerView(for: gesture) else { return }
        stickerView.rotate(gesture: gesture)
    }
    
    fileprivate func stickerView(for gesture: UIGestureRecognizer) -> StickerView? {
        if gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed {
            selectedSticker = nil
        } else {
            if let selectedSticker = self.selectedSticker {
                return selectedSticker
            }
            let location = gesture.location(in: self)
            
            for stickerView in stickers {
                if stickerView.frame.contains(location) {
                    self.selectedSticker = stickerView
                    return stickerView
                }
            }
        }
        
        return nil
    }
}

fileprivate extension StickerContainerView {
    fileprivate func imageFrame() -> CGRect {
        guard let image = imageView.image else { return .zero }
    
        let aspectRatioX = imageView.bounds.size.width / image.size.width
        let aspectRatioY = imageView.bounds.size.height / image.size.height
        if aspectRatioX < aspectRatioY {
            return CGRect(x: 0, y: (imageView.bounds.size.height - aspectRatioX * image.size.height) * 0.5, width: imageView.bounds.size.width, height: aspectRatioX * image.size.height)
        } else {
            return CGRect(x: (imageView.bounds.size.width - aspectRatioY * image.size.width) * 0.5, y: 0, width: aspectRatioY * image.size.width, height: imageView.bounds.size.height)
        }
    }
}

extension StickerContainerView {
    func setupTestData() {
        let images = [
//            SVGKImage(named: "icecream.svg")!,
            SVGKImage(named: "fist.svg")!,
            SVGKImage(named: "hood.svg")!,
            SVGKImage(named: "on_the_run.svg")!,
        ]
                
        let imageFrame = self.imageFrame()
        images.forEach { (image) in
            let stickerView = StickerView(view: SVGKFastImageView(svgkImage: image), boundTo: imageFrame)
            addSubview(stickerView)
            let aspectRatio = image.hasSize() ? image.size.width / image.size.height : 1
            let maximum: CGFloat = 500
            let width = aspectRatio >= 1 ? maximum : maximum * aspectRatio
            let height = aspectRatio <= 1 ? maximum : maximum * aspectRatio
            stickerView.frame.size = CGSize(width: width, height: height)
            stickerView.center = CGPoint(x: imageFrame.width / 2 + imageFrame.minX, y: imageFrame.height / 2 + imageFrame.minY)
            
            self.stickers.append(stickerView)
        }
    }

}
