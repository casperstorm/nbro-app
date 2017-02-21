//
//  StickerBrowserView.swift
//  nbro
//
//  Created by Casper Storm Larsen on 04/02/2017.
//  Copyright © 2017 Bob. All rights reserved.
//

import Foundation
import UIKit

class StickerBrowserView: UIView {
    let collectionView: UICollectionView = {
        let inset: CGFloat = 15
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset)
        layout.minimumInteritemSpacing = inset
        layout.minimumLineSpacing = inset
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        loadingView.hidesWhenStopped = true
        
        return loadingView
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
        backgroundColor = .white
        let subviews = [collectionView, loadingView]
        subviews.forEach { addSubview($0) }
    }
    
    fileprivate func defineLayout() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints { (make) in
            make.center.equalTo(loadingView.superview!)
        }
    }
}
