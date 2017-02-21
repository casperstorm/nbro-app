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
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    let toolsView: ToolsView = {
        let view = ToolsView()
        return view
    }()
        
    let image: UIImage
    var scale: Float = 1
    var stickers: [StickerModel] {
        return stickerViews.map { $0.sticker }
    }
    fileprivate var stickerViews = [StickerView]()
    fileprivate var selectedSticker: StickerView?
    
    init(image: UIImage) {
        self.image = image
        super.init(frame: .zero)
        imageView.image = image
        setupSubviews()
        defineLayout()
        setupGestures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        [imageView, toolsView].forEach { addSubview($0) }
        backgroundColor = .black
    }
    
    private func defineLayout() {
        imageView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(toolsView.snp.top)
        }
        
        toolsView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(80)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageFrame = self.imageFrame()
        self.scale = Float(self.image.size.height / imageFrame.height)
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
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTap(gesture:)))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)
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
        
        let sticker = stickerView.sticker
        let stickerSize = CGSize(width: sticker.size().width * CGFloat(sticker.scale), height: sticker.size().height * CGFloat(sticker.scale))
        let boundingRect = CGRect(x: 0 , y: 0, width: stickerSize.width, height: stickerSize.height)
            .applying(CGAffineTransform(rotationAngle: CGFloat(-sticker.rotation)))
        let stickerHeight = boundingRect.height
        
        let imageFrame = self.imageFrame()
        let converted = CGPoint(x: stickerView.sticker.position.x + imageFrame.minX, y: stickerView.sticker.position.y + imageFrame.minY + (stickerHeight / 4))
        let point = convert(converted, to: toolsView)
        let contains = point.y >= frame.maxY - toolsView.frame.maxY
        
        if gesture.state == .changed {
            UIView.animate(withDuration: 0.25, animations: {
                stickerView.alpha = contains ? 0.5 : 1
            })
            
            if(contains) {
                toolsView.changeState(.delete)
            } else {
                toolsView.changeState(.dragging)
            }
        } else if gesture.state == .cancelled || gesture.state == .ended || gesture.state == .failed {
            if contains {
                stickerView.removeFromSuperview()
                self.stickerViews.removeObject(stickerView)
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                stickerView.alpha = 1
            })
            
            toolsView.changeState(.sticker)
        }
    }
    
    dynamic func pinch(gesture: UIPinchGestureRecognizer) {
        guard let stickerView = self.stickerView(for: gesture) else { return }
        
        stickerView.pinch(gesture: gesture)
    }
    
    dynamic func rotate(gesture: UIRotationGestureRecognizer) {
        guard let stickerView = self.stickerView(for: gesture) else { return }
        
        stickerView.rotate(gesture: gesture)
    }
    
    dynamic func doubleTap(gesture: UITapGestureRecognizer) {
        guard let stickerView = self.stickerView(for: gesture) else { return }
        
        stickerView.doubleTap(gesture: gesture)
    }
    
    fileprivate func stickerView(for gesture: UIGestureRecognizer) -> StickerView? {
        if let selectedSticker = self.selectedSticker {
            if gesture.state == .cancelled || gesture.state == .ended || gesture.state == .failed {
                self.selectedSticker = nil
            }
            return selectedSticker
        }
        let location = gesture.location(in: self)
        
        let sticker = stickerViews.filter { $0.frame.contains(location) }
            .sorted { $0.0.sticker.scale > $0.1.sticker.scale }
            .first
        
        if gesture.state != .recognized {
            selectedSticker = sticker
        }
        
        return sticker
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
    
    func add(sticker: Sticker) {
        let imageFrame = self.imageFrame()
        let sticker = StickerModel(sticker: sticker)
        let stickerView = StickerView(sticker: sticker, boundTo: imageFrame)
        addSubview(stickerView)
        let size = sticker.size()
        stickerView.frame.size = size
        let position = CGPoint(x: imageFrame.width / 2 + imageFrame.minX, y: imageFrame.height / 2 + imageFrame.minY)
        stickerView.center = position
        sticker.position = CGPoint(x: imageFrame.width / 2, y: imageFrame.height / 2)
        
        self.stickerViews.append(stickerView)
    }

}
