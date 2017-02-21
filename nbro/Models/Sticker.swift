//
//  Sticker.swift
//  nbro
//
//  Created by Casper Storm Larsen on 07/02/2017.
//  Copyright © 2017 Bob. All rights reserved.
//

import Foundation
import SVGKit

class Sticker {
    enum Color {
        case black
        case white
    }
    var selectedColor = Color.white
    var currentSVG: SVGKImage {
        switch selectedColor {
        case .white: return whiteSVG
        case .black: return blackSVG
        }
    }
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
    
    func invert() {
        switch selectedColor {
        case .black: self.selectedColor = .white
        case .white: self.selectedColor = .black
        }
    }
}
