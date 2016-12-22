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
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let containerView = transitionContext.containerView
            else {
                return
        }
        
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        let screenBounds = UIScreen.main.bounds
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
        toVC.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9);

        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: transitionContext.isInteractive ? .curveLinear : UIViewAnimationOptions(), animations: {
            fromVC.view.frame = finalFrame
            toVC.view.transform = CGAffineTransform.identity;
            
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}
