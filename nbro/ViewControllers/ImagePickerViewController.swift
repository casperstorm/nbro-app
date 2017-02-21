//
//  ImagePickerViewController.swift
//  nbro
//
//  Created by Casper Storm Larsen on 05/02/2017.
//  Copyright © 2017 Bob. All rights reserved.
//

import Foundation
import UIKit
import Photos

class ImagePickerViewController: UIViewController, UITabBarControllerDelegate {
    var contentView = ImagePickerView()
    let viewModel = ImagePickerView.ViewModel()
    var initial: Bool = true
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        
        contentView.collectionView.register(ImagePickerCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    dynamic private func applicationDidBecomeActive() {
        checkStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkStatus()
        self.tabBarController?.delegate = self
        
        if initial {
            contentView.collectionView.isHidden = true
            initial = false
            DispatchQueue.main.async {
                self.scrollToBottom(animated: false)
                self.contentView.collectionView.isHidden = false
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.delegate = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let aspectRatio: CGFloat = 1
        let inset: CGFloat = 10
        let itemSpace: CGFloat = 5
        let itemsPerRow: CGFloat = 3
        
        let itemWidth: CGFloat = floor((contentView.frame.width - (2 * inset) - ((itemsPerRow - 1) * itemSpace)) / itemsPerRow)
        let itemHeight = itemWidth * aspectRatio
        contentView.layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        contentView.layout.minimumInteritemSpacing = itemSpace
        contentView.layout.minimumLineSpacing = itemSpace
        contentView.collectionView.contentInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController.childViewControllers.first == self {
            scrollToBottom(animated: true)
        }
    }
    
    func scrollToBottom(animated: Bool) {
        if let count = viewModel.assets?.count {
            let lastItem = count - 1
            let lastIndexPath = IndexPath(item: lastItem, section: 0)
            contentView.collectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: animated)
        }
    }
}

extension ImagePickerViewController {
    fileprivate func setupSubviews() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Select image".uppercased()
        
        contentView.informationView.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    fileprivate func checkStatus() {
        let status = PHPhotoLibrary.authorizationStatus()
        contentView.setupPermission(for: status)
        
        if status == .authorized {
            fetchAssets()
        }
    }
    
    fileprivate func fetchAssets() {
        let collection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil).firstObject
        if let collection = collection {
            viewModel.assets = PHAsset.fetchAssets(in: collection, options: nil)
            contentView.collectionView.reloadData()
        }
    }
}

extension ImagePickerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.assets?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImagePickerCollectionViewCell
        
        let scale = UIScreen.main.scale
        let itemSize = contentView.layout.itemSize
        let size = CGSize(width: itemSize.width * scale, height: itemSize.height * scale)
        viewModel.requestImage(for: indexPath, size: size) { image in
            cell.imageView.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.requestImage(for: indexPath, size: PHImageManagerMaximumSize, deliveryMode: .highQualityFormat) { (image) in
            guard let image = image else { return }
            
            let stickerViewController = StickerViewController(image: image)
            self.navigationController?.pushViewController(stickerViewController, animated: true)
        }
    }
}

extension ImagePickerViewController {
    func buttonPressed() {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .denied {
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        } else {
            PHPhotoLibrary.requestAuthorization({ _ in
                DispatchQueue.main.async {
                    self.checkStatus()
                }
            })
        }
    }
}

extension ImagePickerView {
    func setupPermission(for status: PHAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            informationView.titleLabel.font = UIFont.titleBoldFontOfSize(42)
            informationView.titleLabel.text = "Open settings".uppercased()
            informationView.descriptionLabel.text = "Photos permission was declined. Open settings and allow it to continue."
            informationView.isHidden = false
            collectionView.isHidden = true
        case .notDetermined:
            informationView.titleLabel.font = UIFont.titleBoldFontOfSize(44)
            informationView.titleLabel.text = "Allow access".uppercased()
            informationView.descriptionLabel.text = "Use stickers to decorate your photos. Allow access to start."
            informationView.isHidden = false
            collectionView.isHidden = true
        case .authorized:
            informationView.isHidden = true
            collectionView.isHidden = false
        }
    }
}
