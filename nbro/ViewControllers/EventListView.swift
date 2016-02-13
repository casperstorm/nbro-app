//
//  EventView.swift
//  nbro
//
//  Created by Casper Storm Larsen on 13/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class EventListView: UIView {
    let tableView = UITableView.tableView()
    let backgroundImageView = UIImageView.backgroundImageView()
    let vignetteImageView = UIImageView.vignetteImageView()
    let imageContainerView = UIView()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .clearColor()
        setupSubviews()
        defineLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(imageContainerView)
        imageContainerView.addSubview(backgroundImageView)
        imageContainerView.addSubview(vignetteImageView)
        addSubview(tableView)
    }
    
    private func defineLayout() {
        imageContainerView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(imageContainerView.superview!)
        }
        
        vignetteImageView.snp_updateConstraints { (make) -> Void in
            make.edges.equalTo(vignetteImageView.superview!)
        }
        
        tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(tableView.superview!)
        }
        
        self.backgroundImageView.snp_updateConstraints { (make) -> Void in
            make.centerY.equalTo(backgroundImageView.superview!)
            make.left.equalTo(backgroundImageView.superview!)
            
            let imageSize = backgroundImageView.image?.size ?? CGSize.zero
            let factor = CGRectGetHeight(UIScreen.mainScreen().bounds) / imageSize.height
            //todo maybe not use uiscreen? but problem is we dont have height at this point of superview.
            
            make.width.equalTo(imageSize.width * factor)
            make.height.equalTo(imageSize.height * factor)
        }
    }
    
    // MARK : Animation
    
    func animateBackgroundImage() {
        let offset = backgroundImageView.frame.width - backgroundImageView.superview!.frame.width
        
        UIView.animateWithDuration(90.0, delay: 0, options: [.Autoreverse, .Repeat, .CurveLinear], animations: { () -> Void in
            self.backgroundImageView.transform = CGAffineTransformMakeTranslation(-offset, 0)
            
        }) { (finished) -> Void in
            self.backgroundImageView.transform = CGAffineTransformIdentity
        }
    }
}

private extension UITableView {
    static func tableView() -> UITableView {
        let tableView = UITableView()
        tableView.registerClass(EventCell.self, forCellReuseIdentifier: "event")
        tableView.registerClass(LogoCell.self, forCellReuseIdentifier: "logo")
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor = UIColor.clearColor()
        return tableView
    }
}

private extension UIImageView {
    static func backgroundImageView() -> UIImageView {
        let backgroundImageView = UIImageView(image: UIImage(named: "events_background_image_1"))
        return backgroundImageView
    }
    static func vignetteImageView() -> UIImageView {
        return UIImageView(image: UIImage(named: "background_vignette"))
    }
}
