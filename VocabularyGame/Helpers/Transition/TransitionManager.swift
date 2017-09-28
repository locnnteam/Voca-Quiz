//
//  TransitionManager.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 9/23/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit

@objc protocol TransitionManagerDelegate {
    func dismiss()
}

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    var duration = 0.5
    var isPresenting = false
    var snapshot:UIView? {
        
        didSet {
            if let _delegate = delegate {
                let tapGestureRecognizer = UITapGestureRecognizer(target: _delegate, action: #selector(TransitionManagerDelegate.dismiss))
                snapshot?.addGestureRecognizer(tapGestureRecognizer)
            }
        }
        
    }
    
    var delegate: TransitionManagerDelegate?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        let container = transitionContext.containerView
        let moveRight = CGAffineTransform(translationX: container.frame.width, y: 0)
        let moveLeft = CGAffineTransform(translationX: 0, y: 0)
        
        if isPresenting {
            toView.transform = moveLeft
            snapshot = fromView.snapshotView(afterScreenUpdates: true)
            container.addSubview(toView)
            container.addSubview(snapshot!)
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.3, options: UIViewAnimationOptions(), animations: {
            
            if self.isPresenting {
                self.snapshot?.transform = moveRight
                toView.transform = CGAffineTransform.identity
            } else {
                self.snapshot?.transform = CGAffineTransform.identity
                fromView.transform = moveLeft
            }
            
        }, completion: { finished in
            
            transitionContext.completeTransition(true)
            if !self.isPresenting {
                self.snapshot?.removeFromSuperview()
            }
        })
        
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
}

