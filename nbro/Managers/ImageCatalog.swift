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
    private var backgroundImageArray: [UIImage] {
        get {
            return [
                UIImage(named: "background_image_1")!,
                UIImage(named: "background_image_2")!,
                UIImage(named: "background_image_3")!,
                UIImage(named: "background_image_4")!,
            ]
        }
    }
    
    func randomImageFromCatalog() -> UIImage {
        return backgroundImageArray.shuffle.chooseOne

    }
    
    func randomImageFromCatalogAndAvoidImage(avoid: UIImage) -> UIImage {
        var array = backgroundImageArray
        array.removeObjectsInArray([avoid])
        return array.shuffle.chooseOne
    }
}