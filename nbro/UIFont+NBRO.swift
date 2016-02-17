//
//  Fonts.swift
//  nbro
//
//  Created by Casper Storm Larsen on 12/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import UIKit


extension UIFont {
    class func defaultLightFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Exo2-Light", size: size)!
    }
    
    class func defaultMediumFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Exo2-Medium", size: size)!
    }
    
    class func defaultBoldFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Exo2-Bold", size: size)!
    }
    
    class func defaultSemiBoldFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Exo2-SemiBold", size: size)!
    }
    
    class func defaultRegularFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Exo2-Regular", size: size)!
    }
    
    class func titleBoldFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "MyriadPro-BoldCond", size: size)!
    }
}
