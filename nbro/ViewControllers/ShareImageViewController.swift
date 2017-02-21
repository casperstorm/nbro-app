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
    let sticker: Sticker
    var rotation: Float = 0
    var position: CGPoint = .zero
    var scale: Float = 1
    var transform: CGAffineTransform = .identity
    
    init(sticker: Sticker) {
        self.sticker = sticker
    }
    
    func size() -> CGSize {
        let image = sticker.currentSVG
        let aspectRatio = image.hasSize() ? image.size.width / image.size.height : 1
        let maximum: CGFloat = 500
        let width = aspectRatio >= 1 ? maximum : maximum * aspectRatio
        let height = aspectRatio <= 1 ? maximum : maximum * (1 / aspectRatio)
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
        generator.generate { image in
            self.imageView.image = image
        }
        
    }
}
