//
//  ShareImageViewController.swift
//  nbro
//
//  Created by Peter Gammelgaard Poulsen on 07/02/2017.
//  Copyright © 2017 Bob. All rights reserved.
//

import Foundation
import SVGKit

class StickerModel {
    let image: SVGKImage
    var rotation: Float = 0
    var position: CGPoint = .zero
    var scale: Float = 1
    var transform: CGAffineTransform = .identity
    
    init(image: SVGKImage) {
        self.image = image
    }
    
    func size() -> CGSize {
        let aspectRatio = image.hasSize() ? image.size.width / image.size.height : 1
        let maximum: CGFloat = 500
        let width = aspectRatio >= 1 ? maximum : maximum * aspectRatio
        let height = aspectRatio <= 1 ? maximum : maximum * aspectRatio
        return CGSize(width: width, height: height)
    }
}

class ShareImageViewController: UIViewController {
    
    let generator: ImageGenerator
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(image: UIImage, stickers: [StickerModel], scale: Float) {
        self.generator = ImageGenerator(image: image, stickers: stickers, scale: scale)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(imageView.superview!)
        }
        imageView.image = generator.generate()
    }
}

class ImageGenerator {
    let image: UIImage
    let stickers: [StickerModel]
    let scale: Float
    
    init(image: UIImage, stickers: [StickerModel], scale: Float) {
        self.image = image
        self.stickers = stickers
        self.scale = scale
    }
    
    func generate() -> UIImage? {
        let base = image
        let size = base.size
        UIGraphicsBeginImageContext(size)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        base.draw(in: rect)
        
        for sticker in stickers {
            let stickerImage = sticker.image
            let stickerSize = CGSize(width: sticker.size().width * CGFloat(sticker.scale * scale) / UIScreen.main.scale, height: sticker.size().height * CGFloat(sticker.scale * scale) / UIScreen.main.scale)
            let stickerSize2 = CGSize(width: sticker.size().width * CGFloat(sticker.scale * scale), height: sticker.size().height * CGFloat(sticker.scale * scale))

            
            stickerImage.size = stickerSize
            let center = CGPoint(
                x: sticker.position.x * CGFloat(scale),
                y: sticker.position.y * CGFloat(scale))
            
            let boundingRect = CGRect(x: 0, y: 0, width: stickerSize2.width, height: stickerSize2.height).applying(CGAffineTransform(rotationAngle: CGFloat(sticker.rotation)))
//            let stickerCenter = CGPoint(x: boundingRect.size.width / 2, y: boundingRect.size.height / 2)
            let position = CGPoint(
                x: center.x - (boundingRect.size.width / 2),
                y: center.y - (boundingRect.size.height / 2))
            if let uiimage = sticker.image.uiImage, let ciimage = CIImage(image: uiimage) {
//                let transform = CGAffineTransform(rotationAngle: CGFloat(-sticker.rotation))
                let transform = CGAffineTransform(translationX: center.x, y: center.y)
                    .rotated(by: CGFloat(-sticker.rotation))
                    .translatedBy(x: -center.x, y: -center.y)
                let transformed = ciimage.applying(transform)
                let image = UIImage(ciImage: transformed)
                image.draw(at: position)
            }
        }

        let merged = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return merged
    }
}
