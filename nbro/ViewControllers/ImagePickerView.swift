//
//  ImagePickerView.swift
//  nbro
//
//  Created by Casper Storm Larsen on 05/02/2017.
//  Copyright © 2017 Bob. All rights reserved.
//

import Foundation
import UIKit

class ImagePickerView: UIView {
    let informationView = InformationView()
    let layout = UICollectionViewFlowLayout()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.alwaysBounceVertical = true
        
        return collectionView
    }()

    lazy var helperView: ImagePickerHelperView = {
        let image = ImagePickerHelperView()
        image.textLabel.text = "Select a image\nthen apply stickers!".uppercased()
        return image
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        setupSubviews()
        defineLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        backgroundColor = UIColor(hex:0x000000)
        
        [ collectionView, informationView, helperView ].forEach { addSubview($0) }
    }
    
    fileprivate func defineLayout() {
        helperView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(helperView.superview!)
            make.height.equalTo(60)
        }
        
        informationView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(collectionView.superview!)
        }
    }
}
