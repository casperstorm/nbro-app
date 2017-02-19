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
        func requestImage(for indexPath: IndexPath, size: CGSize, completion: @escaping ((UIImage?) -> Void)) {
            guard let asset = assets?[indexPath.item] else {
                completion(nil)
                return
            }
            
            let imageManager = PHImageManager.default()
            
            if let request = requests[indexPath] {
                imageManager.cancelImageRequest(request)
            }
            
            let imageRequest = imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: nil) { (image, _) in
                completion(image)
            }
            requests[indexPath] = imageRequest
        }
    }
}
