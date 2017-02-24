//
//  ImageCatalogManager.swift
//  nbro
//
//  Created by Casper Storm Larsen on 16/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class ImageCatalog {
    fileprivate var backgroundImageArray: [UIImage] {
        get {
            return [
                UIImage(named: "background_image_1")!,
                UIImage(named: "background_image_2")!,
                UIImage(named: "background_image_3")!,
                UIImage(named: "background_image_4")!,
                UIImage(named: "background_image_5")!,
                UIImage(named: "background_image_6")!,
                UIImage(named: "background_image_7")!,
                UIImage(named: "background_image_8")!,
                UIImage(named: "background_image_9")!,
                UIImage(named: "background_image_10")!,
            ]
        }
    }
    
    func randomImageFromCatalog() -> UIImage {
        return backgroundImageArray.shuffle.chooseOne
    }
    
    func randomImageFromCatalogAndAvoidImage(_ avoid: UIImage) -> UIImage {
        var array = backgroundImageArray
        array.removeObjectsInArray([avoid])
        return array.shuffle.chooseOne
    }
}
