//
//  Fonts.swift
//  nbro
//
//  Created by Casper Storm Larsen on 12/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import UIKit


extension UIFont {
    class func defaultLightFontOfSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Exo2-Light", size: size)!
    }
    
    class func defaultMediumFontOfSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Exo2-Medium", size: size)!
    }
    
    class func defaultBoldFontOfSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Exo2-Bold", size: size)!
    }
    
    class func defaultSemiBoldFontOfSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Exo2-SemiBold", size: size)!
    }
    
    class func defaultRegularFontOfSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Exo2-Regular", size: size)!
    }
    
    class func titleBoldFontOfSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "MyriadPro-BoldCond", size: size)!
    }
}
