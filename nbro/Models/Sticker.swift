//
//  Sticker.swift
//  nbro
//
//  Created by Casper Storm Larsen on 07/02/2017.
//  Copyright © 2017 Bob. All rights reserved.
//

import Foundation
import SVGKit

struct Sticker {
    let blackSVG: SVGKImage
    let whiteSVG: SVGKImage
    let blackPNG: UIImage
    let whitePNG: UIImage

    init(blackSVG: SVGKImage, whiteSVG: SVGKImage, blackPNG: UIImage, whitePNG: UIImage) {
        self.blackPNG = blackPNG
        self.blackSVG = blackSVG
        self.whitePNG = whitePNG
        self.whiteSVG = whiteSVG
    }
}
