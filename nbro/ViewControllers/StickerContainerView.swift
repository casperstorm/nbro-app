//
//  StickerContainerView.swift
//  nbro
//
//  Created by Peter Gammelgaard Poulsen on 04/02/2017.
//  Copyright © 2017 Bob. All rights reserved.
//

import Foundation
import SVGKit
import AVFoundation

class StickerContainerView: UIView {
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .yellow
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "background_image.jpg")
        
        return imageView
    }()
    
    fileprivate var stickers = [StickerView]()
    
    init() {
        super.init(frame: .zero)
        
        setupSubviews()
        defineLayout()
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
}



fileprivate extension StickerContainerView {
    fileprivate func imageFrame() -> CGRect {
        guard let image = imageView.image else { return .zero }
        
//        return AVMakeRect(aspectRatio: image.size, insideRect: imageView.bounds)
//
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
            SVGKImage(named: "icecream.svg")!,
            SVGKImage(named: "fist.svg")!,
            SVGKImage(named: "midweek_madness.svg")!,
        ]
                
        let imageFrame = self.imageFrame()
        let stickers = images.map { StickerView(view: SVGKFastImageView(svgkImage: $0), boundTo: imageFrame) }
        stickers.forEach { (stickerView) in
            addSubview(stickerView)
            stickerView.frame.size = CGSize(width: 500, height: 500)
            stickerView.center = CGPoint(x: imageFrame.width / 2 + imageFrame.minX, y: imageFrame.height / 2 + imageFrame.minY)
            
            self.stickers.append(stickerView)
        }
    }

}
