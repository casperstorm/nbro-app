//
//  LaunchImageView.swift
//  nbro
//
//  Created by Peter Gammelgaard Poulsen on 13/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class LaunchImageView: UIImageView {
    
    fileprivate static let launchImage: UIImage? = {
        let imageName: String = {
            let scale = UIScreen.main.scale
            let height = UIScreen.main.bounds.height
            if scale > 2.0 {
                return "LaunchImage-800-Portrait-736h" // iPhone 6Plus
            } else if height == 667.0 {
                return "LaunchImage-800-667h"
            } else if height == 568.0 {
                return  "LaunchImage-700-568h"
            } else {
                return "LaunchImage-700"
            }
        }()
        
        return UIImage(named: imageName)
    }()
    
    fileprivate static var launchImageView: LaunchImageView?
    
    static func show() {
        if let window = UIApplication.shared.keyWindow {
            let launchImageView: LaunchImageView = {
                if let launchImageView = self.launchImageView {
                    return launchImageView
                } else {
                    let launchImageView = LaunchImageView()
                    launchImageView.image = self.launchImage
                    launchImageView.frame = UIScreen.main.bounds
                    return launchImageView
                }
            }()
            
            window.addSubview(launchImageView)
            
            self.launchImageView = launchImageView
        }
    }
    
    static func hide() {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            launchImageView?.alpha = 0.0
            }, completion: { (finished) -> Void in
                 launchImageView?.removeFromSuperview()
        }) 
    }
    
}
