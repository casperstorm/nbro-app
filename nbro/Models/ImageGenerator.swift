//
//  ImageGenerator.swift
//  nbro
//
//  Created by Peter Gammelgaard Poulsen on 14/02/2017.
//  Copyright © 2017 Bob. All rights reserved.
//

import Foundation

class ImageGenerator {
    let image: UIImage
    let stickers: [StickerModel]
    let scale: Float
    
    init(image: UIImage, stickers: [StickerModel], scale: Float) {
        self.image = image
        self.stickers = stickers
        self.scale = scale
    }
    
    func generate(block: @escaping ((UIImage?) -> Void)) {
        let stickers = self.stickers
        let scale = self.scale
        let base = self.image
        let size = base.size
        
        DispatchQueue(label: "ImageGenerator").async {
            UIGraphicsBeginImageContext(size)
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            base.draw(in: rect)
            
            stickers.map { (position: self.position(for: $0, scale: scale),
                        image: self.image(for: $0, scale: scale)) }
                .forEach { $0.image?.draw(at: $0.position) }

            let merged = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            DispatchQueue.main.async {
                block(merged)
            }
        }
    }
    
    private func position(for sticker: StickerModel, scale: Float) -> CGPoint {
        let stickerSize = CGSize(width: sticker.size().width * CGFloat(sticker.scale * scale), height: sticker.size().height * CGFloat(sticker.scale * scale))
        let boundingRect = CGRect(x: 0 , y: 0, width: stickerSize.width, height: stickerSize.height)
            .applying(CGAffineTransform(rotationAngle: CGFloat(-sticker.rotation)))
        let center = CGPoint(
            x: sticker.position.x * CGFloat(scale),
            y: sticker.position.y * CGFloat(scale))
        return CGPoint(x: center.x - boundingRect.width / 2, y: center.y - boundingRect.height / 2)
    }
    
    private func image(for sticker: StickerModel, scale: Float) -> UIImage? {
        let stickerImage = sticker.sticker.currentSVG
        let stickerSize = CGSize(width: sticker.size().width * CGFloat(sticker.scale * scale), height: sticker.size().height * CGFloat(sticker.scale * scale))
        
        let screenScale = 1 / UIScreen.main.scale
        stickerImage.size = stickerSize.applying(CGAffineTransform(scaleX: screenScale , y: screenScale))
        
        guard let uiimage = stickerImage.uiImage, let ciimage = CIImage(image: uiimage) else { return nil }
        
        let transform = CGAffineTransform(rotationAngle: CGFloat(-sticker.rotation))
        let transformed = ciimage.transformed(by: transform)
        let image = UIImage(ciImage: transformed)
        return image
    }
}
