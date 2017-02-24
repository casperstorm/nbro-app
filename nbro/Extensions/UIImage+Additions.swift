//
//  UIImage+Additions.swft
//  nbro
//
//  Created by Casper Storm Larsen on 15/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation

public extension UIImage {
    convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage!)!)
    }
    
    func convertToGrayScale() -> UIImage {
        let imageRect:CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = size.width
        let height = size.height
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context?.draw(cgImage!, in: imageRect)
        let imageRef = context?.makeImage()
        let newImage = UIImage(cgImage: imageRef!)
        
        return newImage
    }
}
