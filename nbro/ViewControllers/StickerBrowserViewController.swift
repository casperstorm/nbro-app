//
//  StickerBrowserViewController.swift
//  nbro
//
//  Created by Casper Storm Larsen on 04/02/2017.
//  Copyright © 2017 Bob. All rights reserved.
//

import Foundation
import UIKit
import SVGKit

fileprivate class ViewModel {
    let stickers: [SVGKImage]
    
    init() {
        stickers = [
            SVGKImage(named: "fist.svg")!,
            SVGKImage(named: "hood.svg")!,
            SVGKImage(named: "on_the_run.svg")!
        ]
    }
}

class StickerBrowserViewController: UIViewController {
    var actionHandler: ((SVGKImage) -> ())?
    var contentView = StickerBrowserView()
    fileprivate let viewModel = ViewModel()
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
}

extension StickerBrowserViewController {
    fileprivate func setupSubviews() {        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Stickers".uppercased()
        
        contentView.collectionView.register(StickerBrowserCell.self, forCellWithReuseIdentifier: "sticker-cell")
        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = self
    }
}

extension StickerBrowserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.stickers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sticker-cell", for: indexPath) as! StickerBrowserCell
        cell.imageView.image = viewModel.stickers[indexPath.row].uiImage
        return cell
    }
}

extension StickerBrowserViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        return CGSize(width: screenWidth / 5, height: screenWidth / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = viewModel.stickers[indexPath.row]
        actionHandler?(image)
    }
}
