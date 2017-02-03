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

class EventListView: UIView, CAAnimationDelegate {
    
    var showNotAuthenticatedView = false {
        didSet {
            notAuthenticatedView.isHidden = !showNotAuthenticatedView
            tableView.isHidden = showNotAuthenticatedView
            
            if showNotAuthenticatedView && !oldValue {
                notAuthenticatedView.alpha = 0.0
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.notAuthenticatedView.alpha = 1.0
                })

            }
        }
    }
    
    let tableView = UITableView.tableView()
    let backgroundImageView = UIImageView.backgroundImageView()
    let vignetteImageView = UIImageView.vignetteImageView()
    let imageContainerView = UIView()
    let aboutButton = UIButton.aboutButton()
    let userButtonView = CircularUserButtonView()
    let refreshControl = UIRefreshControl.refreshControl()
    let notAuthenticatedView = NotAuthenticatedView()
    var didPresentUserButtons = Bool()

    init() {
        super.init(frame: CGRect.zero)
        notAuthenticatedView.isHidden = true
        backgroundColor = .clear
        setupSubviews()
        defineLayout()        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        tableView.addSubview(refreshControl)
        addSubview(imageContainerView)
        imageContainerView.addSubview(backgroundImageView)
        imageContainerView.addSubview(vignetteImageView)
        addSubview(tableView)
        addSubview(aboutButton)
        addSubview(notAuthenticatedView)
        addSubview(userButtonView)

        if refreshControl.subviews.count > 0 {
            refreshControl.subviews[0].frame = CGRect(x: 0, y: 30, width: 0, height: 0)
        }
    }
    
    fileprivate func defineLayout() {
        imageContainerView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(imageContainerView.superview!)
        }
        
        vignetteImageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(vignetteImageView.superview!).inset(-1)
        }
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(tableView.superview!)
        }
        
        backgroundImageView.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(backgroundImageView.superview!)
            make.left.equalTo(backgroundImageView.superview!)
            
            let imageSize = backgroundImageView.image?.size ?? CGSize.zero
            let factor = UIScreen.main.bounds.height / imageSize.height
            //todo maybe not use uiscreen? but problem is we dont have height at this point of superview.
            
            make.width.equalTo(imageSize.width * factor)
            make.height.equalTo(imageSize.height * factor)
        }

        notAuthenticatedView.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(notAuthenticatedView.superview!)
            make.leading.trailing.equalTo(notAuthenticatedView.superview!).inset(50)
        }
        
        userButtonView.snp.makeConstraints { (make) in
            make.bottom.equalTo(userButtonView.superview!).inset(20)
            make.right.equalTo(userButtonView.superview!).inset(20)
            make.width.height.equalTo(60)
        }
    }
    
    override func updateConstraints() {
        aboutButton.snp.remakeConstraints { (make) in
            if(FacebookManager.authenticated()) {
                make.centerY.equalTo(userButtonView).offset(4)
                make.right.equalTo(userButtonView.snp.left).offset(-10)
            } else {
                make.right.bottom.equalTo(aboutButton.superview!).inset(20)
            }
            
            make.width.height.equalTo(47)
        }
        
        super.updateConstraints()
    }
    
    // MARK : Animation
    
    func stopBackgroundAnimation() {
        self.backgroundImageView.layer.removeAllAnimations()
        self.backgroundImageView.transform = CGAffineTransform.identity
    }
    
    func animateBackgroundImage() {
        let offset = backgroundImageView.frame.width - backgroundImageView.superview!.frame.width
        
        UIView.animate(withDuration: 90, delay: 0, options: [.autoreverse, .repeat, .curveLinear], animations: { () -> Void in
            self.backgroundImageView.transform = CGAffineTransform(translationX: -offset, y: 0)
            
        }) { (finished) -> Void in
            self.backgroundImageView.transform = CGAffineTransform.identity
        }
    }
    
    func animateBackgroundImageCrossfadeChange() {
        let isAnimating = backgroundImageView.layer.animationKeys()!.contains("animateContents")
        if(!isAnimating) {
            if let backgroundImage = backgroundImageView.image {
                let fromImage = backgroundImage
                let toImage = ImageCatalog().randomImageFromCatalogAndAvoidImage(fromImage)
                
                let crossfade = CABasicAnimation(keyPath: "contents")
                crossfade.duration = 1.0
                crossfade.fromValue = fromImage
                crossfade.toValue = toImage
                crossfade.delegate = self
                crossfade.isRemovedOnCompletion = true
                backgroundImageView.layer .add(crossfade, forKey: "animateContents")
                backgroundImageView.image = toImage;
            }
        }
    }
    

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let didFinishAnimating = backgroundImageView.layer.animationKeys()!.contains("animateContents")
        if(!didFinishAnimating) {
            backgroundImageView.layer.removeAnimation(forKey: "animateContents")
        }
    }
}

private extension UIRefreshControl {
    static func refreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        return refreshControl
    }
}

private extension UITableView {
    static func tableView() -> UITableView {
        let tableView = UITableView()
        tableView.register(EventCell.self, forCellReuseIdentifier: "event")
        tableView.register(LogoCell.self, forCellReuseIdentifier: "logo")
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        return tableView
    }
}

private extension UIImageView {
    static func backgroundImageView() -> UIImageView {
        let image = ImageCatalog().randomImageFromCatalog()
        let backgroundImageView = UIImageView(image: image)
        return backgroundImageView
    }
    static func vignetteImageView() -> UIImageView {
        return UIImageView(image: UIImage(named: "background_vignette"))
    }
}

private extension UIButton {
    static func aboutButton() -> UIButton {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "about_button"), for: UIControlState())
        return button
    }
}
