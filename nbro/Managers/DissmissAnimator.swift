//
//  DissmissAnimator.swift
//  nbro
//
//  Created by Casper Storm Larsen on 26/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import UIKit

class DismissAnimator : NSObject {

    
    
}

extension DismissAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let containerView = transitionContext.containerView()
            else {
                return
        }
        
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        let screenBounds = UIScreen.mainScreen().bounds
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
        toVC.view.transform = CGAffineTransformMakeScale(0.9, 0.9);

        
        UIView.animateWithDuration(
            transitionDuration(transitionContext), delay: 0.0, options: transitionContext.isInteractive() ? .CurveLinear : .CurveEaseInOut, animations: {
            fromVC.view.frame = finalFrame
            toVC.view.transform = CGAffineTransformIdentity;
            
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
        )
    }
}