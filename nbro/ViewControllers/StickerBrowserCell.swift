//
//  StickerBrowserCell.swift
//  nbro
//
//  Created by Casper Storm Larsen on 04/02/2017.
//  Copyright © 2017 Bob. All rights reserved.
//

import Foundation
import UIKit

class StickerBrowserCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        defineLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StickerBrowserCell {
    fileprivate func setupSubviews() {
        backgroundColor = .clear
        let subviews = [imageView]
        subviews.forEach { addSubview($0) }
    }
    
    fileprivate func defineLayouts() {
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(12)
        }
    }
}
