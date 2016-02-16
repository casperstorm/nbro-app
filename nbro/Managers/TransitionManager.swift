//
//  TransitionManager.swift
//  nbro
//
//  Created by Casper Storm Larsen on 16/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    private var style = AnimaionStyle.SwipeRight
    enum AnimaionStyle {
        case SwipeRight
        case SwipeLeft
    }

    init(style:AnimaionStyle) {
        self.style = style
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        switch style {
        case .SwipeRight:
            swipeTransition(false, transitionContext: transitionContext)
        case .SwipeLeft:
            swipeTransition(true, transitionContext: transitionContext)
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.6
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    //MARK: Animations
    
    private func swipeTransition(reverse: Bool, transitionContext: UIViewControllerContextTransitioning) {

        guard let container: UIView = transitionContext.containerView() else {
            return
        }
        guard let fromViewController: UIViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) else {
            return
        }
        guard let toViewController: UIViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
            return
        }
        
        let offScreenRight = CGAffineTransformMakeTranslation(container.frame.width, 0)
        let offScreenLeft = CGAffineTransformMakeTranslation(-container.frame.width, 0)
        
        toViewController.view.transform = reverse ? offScreenLeft : offScreenRight
        toViewController.view.frame = CGRectMake(toViewController.view.frame.origin.x,
                                                 toViewController.view.frame.origin.y,
                                                 fromViewController.view.frame.width,
                                                 fromViewController.view.frame.height)
        
        
        // add the both views to our view controller
        container.addSubview(toViewController.view)
        container.addSubview(fromViewController.view)
        
        let duration = transitionDuration(transitionContext)
        UIView.animateWithDuration(duration, delay: 0.0,
                                             usingSpringWithDamping: 0.7,
                                             initialSpringVelocity: 0.8,
                                             options: .CurveLinear,
                                             animations: {
                                                
                                                fromViewController.view.transform = reverse ? offScreenRight : offScreenLeft
                                                toViewController.view.transform = CGAffineTransformIdentity
                                                
            }, completion: { finished in
                transitionContext.completeTransition(true)
        })
    }
    
}