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
    enum ColorState {
        case white
        case black
    }
    
    let stickers: [Sticker]
    var state: ColorState
    
    init() {
        state = .white
        stickers = [
            Sticker(blackSVG: SVGKImage(named: "sticker_nbro_black.svg")!, whiteSVG: SVGKImage(named: "sticker_nbro_white.svg")!, blackPNG: #imageLiteral(resourceName: "sticker_nbro_black"), whitePNG: #imageLiteral(resourceName: "sticker_nbro_white")),
            Sticker(blackSVG: SVGKImage(named: "sticker_nbro_alt_black.svg")!, whiteSVG: SVGKImage(named: "sticker_nbro_alt_white.svg")!, blackPNG: #imageLiteral(resourceName: "sticker_nbro_alt_black"), whitePNG: #imageLiteral(resourceName: "sticker_nbro_alt_white"))
        ]
    }
}

class StickerBrowserViewController: UIViewController {
    var actionHandler: ((SVGKImage) -> ())?
    var contentView = StickerBrowserView()
    var colorButton: UIBarButtonItem?
    var cancelButton: UIBarButtonItem?
    
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
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Stickers".uppercased()
        
        contentView.collectionView.register(StickerBrowserCell.self, forCellWithReuseIdentifier: "sticker-cell")
        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = self
        
        colorButton = UIBarButtonItem(image: #imageLiteral(resourceName: "color_button"), style: .plain, target: self, action: #selector(colorButtonTapped))
        colorButton?.tintColor = .black
        self.navigationItem.rightBarButtonItem = colorButton
        
        cancelButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_cancel"), style: .plain, target: self, action: #selector(dismissTapped))
        cancelButton?.tintColor = .black
        self.navigationItem.leftBarButtonItem = cancelButton
    }
}

extension StickerBrowserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.stickers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sticker-cell", for: indexPath) as! StickerBrowserCell
        let sticker = viewModel.stickers[indexPath.row]
        switch viewModel.state {
        case .white:
            cell.imageView.image = sticker.blackPNG
        case .black:
            cell.imageView.image = sticker.whitePNG
        }
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
        let sticker = viewModel.stickers[indexPath.row]
        switch viewModel.state {
        case .white:
            actionHandler?(sticker.blackSVG)
        case .black:
            actionHandler?(sticker.whiteSVG)
        }
    }
}

extension StickerBrowserViewController {
    func colorButtonTapped() {
        switch viewModel.state {
        case .white:
            navigationController?.navigationBar.barStyle = .black
            navigationController?.navigationBar.barTintColor = .black
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName: UIFont.defaultBoldFontOfSize(18)]
            contentView.backgroundColor = .black
            colorButton?.tintColor = .white
            cancelButton?.tintColor = .white
            self.viewModel.state = .black
            self.contentView.collectionView.reloadData()
        case .black:
            navigationController?.navigationBar.barStyle = .default
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName: UIFont.defaultBoldFontOfSize(18)]
            contentView.backgroundColor = .white
            colorButton?.tintColor = .black
            cancelButton?.tintColor = .black

            self.viewModel.state = .white
            self.contentView.collectionView.reloadData()
        }
    }
    
    func dismissTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
