//
//  UIColor+HEX.swift
//  nbro
//
//  Created by Casper Storm Larsen on 15/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

extension UIColor {
    convenience init(hex:Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    convenience init(hex:Int, alpha: Float) {
        self.init(red:CGFloat((hex >> 16) & 0xff) / 255.0, green:CGFloat((hex >> 8) & 0xff) / 255.0, blue:CGFloat(hex & 0xff) / 255.0, alpha:CGFloat(alpha))
    }
}