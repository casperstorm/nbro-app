//
//  ImagePickerCollectionViewCell.swift
//  nbro
//
//  Created by Peter Gammelgaard Poulsen on 19/02/2017.
//  Copyright © 2017 Bob. All rights reserved.
//

import Foundation
import UIKit

class ImagePickerCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        defineLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImagePickerCollectionViewCell {
    fileprivate func setupSubviews() {
        contentView.addSubview(imageView)
    }
    
    fileprivate func defineLayout() {
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(imageView.superview!)
        }
    }
}
