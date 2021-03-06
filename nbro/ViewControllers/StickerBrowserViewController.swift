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
    
    var stickers: [Sticker]?
    var state: ColorState
    
    init() {
        state = .white
    }
    
    func loadStickers(completion: @escaping (() -> Void)) {
        DispatchQueue(label: "Load stickers").async {
            let stickers = [
                Sticker(blackSVG: SVGKImage(named: "sticker_nbro_black.svg")!,
                        whiteSVG: SVGKImage(named: "sticker_nbro_white.svg")!,
                        blackPNG: #imageLiteral(resourceName: "sticker_nbro_black"),
                        whitePNG: #imageLiteral(resourceName: "sticker_nbro_white")),
                Sticker(blackSVG: SVGKImage(named: "sticker_nbro_alt_black.svg")!,
                        whiteSVG: SVGKImage(named: "sticker_nbro_alt_white.svg")!,
                        blackPNG: #imageLiteral(resourceName: "sticker_nbro_alt_black"),
                        whitePNG: #imageLiteral(resourceName: "sticker_nbro_alt_white")),
                Sticker(blackSVG: SVGKImage(named: "sticker_daf_black.svg")!,
                        whiteSVG: SVGKImage(named: "sticker_daf_white.svg")!,
                        blackPNG: #imageLiteral(resourceName: "sticker_daf_black"),
                        whitePNG: #imageLiteral(resourceName: "sticker_daf_white")),
                Sticker(blackSVG: SVGKImage(named: "sticker_bloody_black.svg")!,
                        whiteSVG: SVGKImage(named: "sticker_bloody_white.svg")!,
                        blackPNG: #imageLiteral(resourceName: "sticker_bloody_black"),
                        whitePNG: #imageLiteral(resourceName: "sticker_bloody_white")),
                Sticker(blackSVG: SVGKImage(named: "sticker_mellow_black.svg")!,
                        whiteSVG: SVGKImage(named: "sticker_mellow_white.svg")!,
                        blackPNG: #imageLiteral(resourceName: "sticker_mellow_black"),
                        whitePNG: #imageLiteral(resourceName: "sticker_mellow_white")),
                Sticker(blackSVG: SVGKImage(named: "sticker_madness_black.svg")!,
                        whiteSVG: SVGKImage(named: "sticker_madness_white.svg")!,
                        blackPNG: #imageLiteral(resourceName: "sticker_madness_black"),
                        whitePNG: #imageLiteral(resourceName: "sticker_madness_white")),
                Sticker(blackSVG: SVGKImage(named: "sticker_tgit_black.svg")!,
                        whiteSVG: SVGKImage(named: "sticker_tgit_white.svg")!,
                        blackPNG: #imageLiteral(resourceName: "sticker_tgit_black"),
                        whitePNG: #imageLiteral(resourceName: "sticker_tgit_white")),
                Sticker(blackSVG: SVGKImage(named: "sticker_friday_black.svg")!,
                        whiteSVG: SVGKImage(named: "sticker_friday_white.svg")!,
                        blackPNG: #imageLiteral(resourceName: "sticker_friday_black"),
                        whitePNG: #imageLiteral(resourceName: "sticker_friday_white")),
                Sticker(blackSVG: SVGKImage(named: "sticker_long_black.svg")!,
                        whiteSVG: SVGKImage(named: "sticker_long_white.svg")!,
                        blackPNG: #imageLiteral(resourceName: "sticker_long_black"),
                        whitePNG: #imageLiteral(resourceName: "sticker_long_white")),
                Sticker(blackSVG: SVGKImage(named: "sticker_sunday_black.svg")!,
                        whiteSVG: SVGKImage(named: "sticker_sunday_white.svg")!,
                        blackPNG: #imageLiteral(resourceName: "sticker_sunday_black"),
                        whitePNG: #imageLiteral(resourceName: "sticker_sunday_white")),
                Sticker(blackSVG: SVGKImage(named: "sticker_run-repeat_black.svg")!,
                        whiteSVG: SVGKImage(named: "sticker_run-repeat_white.svg")!,
                        blackPNG: #imageLiteral(resourceName: "sticker_run-repeat_black"),
                        whitePNG: #imageLiteral(resourceName: "sticker_run-repeat_white")),
                Sticker(blackSVG: SVGKImage(named: "sticker_runner_black.svg")!,
                        whiteSVG: SVGKImage(named: "sticker_runner_white.svg")!,
                        blackPNG: #imageLiteral(resourceName: "sticker_runner_black"),
                        whitePNG: #imageLiteral(resourceName: "sticker_runner_white")),
                Sticker(blackSVG: SVGKImage(named: "sticker_foamfinger_black.svg")!,
                        whiteSVG: SVGKImage(named: "sticker_foamfinger_white.svg")!,
                        blackPNG: #imageLiteral(resourceName: "sticker_foamfinger_black"),
                        whitePNG: #imageLiteral(resourceName: "sticker_foamfinger_white")),
                Sticker(blackSVG: SVGKImage(named: "sticker_btg_black.svg")!,
                        whiteSVG: SVGKImage(named: "sticker_btg_white.svg")!,
                        blackPNG: #imageLiteral(resourceName: "sticker_btg_black"),
                        whitePNG: #imageLiteral(resourceName: "sticker_btg_white")),
                Sticker(blackSVG: SVGKImage(named: "sticker_neverrunalone_black.svg")!,
                        whiteSVG: SVGKImage(named: "sticker_neverrunalone_white.svg")!,
                        blackPNG: #imageLiteral(resourceName: "sticker_neverrunalone_black"),
                        whitePNG: #imageLiteral(resourceName: "sticker_neverrunalone_white")),
            ]
            
            DispatchQueue.main.async {
                self.stickers = stickers
                completion()
            }
        }
    }
}

class StickerBrowserViewController: UIViewController {
    var actionHandler: ((Sticker) -> ())?
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
        
        contentView.loadingView.startAnimating()
        viewModel.loadStickers { [weak self] in
            self?.contentView.loadingView.stopAnimating()
            self?.contentView.collectionView.reloadData()
        }
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
        cancelButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_cancel"), style: .plain, target: self, action: #selector(dismissTapped))
        
        self.navigationItem.rightBarButtonItem = colorButton
        self.navigationItem.leftBarButtonItem = cancelButton

        switchToState(state: .black)
    }
}

extension StickerBrowserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.stickers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sticker = viewModel.stickers?[indexPath.row] else { fatalError() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sticker-cell", for: indexPath) as! StickerBrowserCell
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
        return CGSize(width: screenWidth / 4, height: screenWidth / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sticker = viewModel.stickers?[indexPath.row] else { return }
        switch viewModel.state {
        case .white:
            sticker.selectedColor = .black
            actionHandler?(sticker)
        case .black:
            sticker.selectedColor = .white
            actionHandler?(sticker)
        }
    }
}

extension StickerBrowserViewController {
    @objc func colorButtonTapped() {
        switch viewModel.state {
        case .white:
            switchToState(state: .black)
        case .black:
            switchToState(state: .white)
        }
    }
    
    @objc func dismissTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func switchToState(state: ViewModel.ColorState) {
        switch state {
        case .black:
            navigationController?.navigationBar.barStyle = .black
            navigationController?.navigationBar.barTintColor = .black
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font: UIFont.defaultBoldFontOfSize(18)]
            contentView.backgroundColor = .black
            colorButton?.tintColor = .white
            cancelButton?.tintColor = .white
            self.viewModel.state = .black
            self.contentView.collectionView.reloadData()
        case .white:
            navigationController?.navigationBar.barStyle = .default
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black, NSAttributedStringKey.font: UIFont.defaultBoldFontOfSize(18)]
            contentView.backgroundColor = .white
            colorButton?.tintColor = .black
            cancelButton?.tintColor = .black
            
            self.viewModel.state = .white
            self.contentView.collectionView.reloadData()
        }
    }
}
