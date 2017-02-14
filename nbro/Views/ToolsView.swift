//
//  ToolsView.swift
//  nbro
//
//  Created by Casper Storm Larsen on 14/02/2017.
//  Copyright © 2017 Bob. All rights reserved.
//

import Foundation
import UIKit

class ToolsView: UIView {
    fileprivate var currentState: State = .sticker
    
    enum State {
        case sticker, dragging, delete, loading
    }
    
    let button: UIButton = {
       return UIButton()
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "add_stickers_icon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        activity.color = .white
        return activity
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        setupSubviews()
        defineLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ToolsView {
    fileprivate func setupSubviews() {
        backgroundColor = .black
        
        addSubview(button)
        addSubview(imageView)
        addSubview(activityIndicatorView)

        changeState(.sticker)
    }
    
    fileprivate func defineLayout() {
        
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        activityIndicatorView.snp.makeConstraints { (make) in
            make.center.equalTo(imageView)
        }
        
        button.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension ToolsView {
    func changeState(_ state: State) {
        guard state != currentState else { return }
        currentState = state
        let newImage: UIImage?
        switch state {
        case .delete:
            startWiggle()
            newImage = #imageLiteral(resourceName: "open_trash")
            button.isEnabled = false
            activityIndicatorView.stopAnimating()
        case .dragging:
            stopWiggle()
            newImage = #imageLiteral(resourceName: "closed_trash")
            button.isEnabled = false
            activityIndicatorView.stopAnimating()
        case .sticker:
            stopWiggle()
            newImage = #imageLiteral(resourceName: "add_stickers_icon")
            button.isEnabled = true
            activityIndicatorView.stopAnimating()
        case .loading:
            stopWiggle()
            newImage = nil
            button.isEnabled = false
            activityIndicatorView.startAnimating()
        }
        
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.imageView.image = newImage
        }, completion: nil)
    }
    
    func startWiggle() {
        let transformAnim  = CAKeyframeAnimation(keyPath:"transform")
        let angle: CGFloat = 0.08
        transformAnim.values  = [NSValue(caTransform3D: CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)),NSValue(caTransform3D: CATransform3DMakeRotation(-angle , 0, 0, 1))]
        transformAnim.autoreverses = true
        transformAnim.duration  = 0.115
        transformAnim.repeatCount = Float.infinity
        imageView.layer.add(transformAnim, forKey: "transform")
    }
    
    func stopWiggle() {
        imageView.layer.removeAnimation(forKey: "transform")
    }
}
