//
//  ImagePickerViewModel.swift
//  nbro
//
//  Created by Peter Gammelgaard Poulsen on 19/02/2017.
//  Copyright © 2017 Bob. All rights reserved.
//

import Foundation
import Photos

extension ImagePickerView {
    class ViewModel {
        var assets: PHFetchResult<PHAsset>?
        private var requests: [IndexPath: PHImageRequestID] = [:]
        func requestImage(for indexPath: IndexPath, size: CGSize, deliveryMode: PHImageRequestOptionsDeliveryMode = .opportunistic, completion: @escaping ((UIImage?) -> Void)) {
            guard let assets = self.assets else {
                completion(nil)
                return
            }
            let index = indexPath.item
            let asset = assets[index]
            
            let imageManager = PHImageManager.default()
            
            if let request = requests[indexPath] {
                imageManager.cancelImageRequest(request)
            }
            
            let options = PHImageRequestOptions()
            options.deliveryMode = deliveryMode
            let imageRequest = imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: options) { (image, _) in
                completion(image)
            }
            requests[indexPath] = imageRequest
        }
    }
}
