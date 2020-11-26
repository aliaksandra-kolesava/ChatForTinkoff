//
//  AnimationTransitioning.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 26.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation
import UIKit

class AnimationTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: Double
    private let presentOrDismiss: PresentOrDismiss
    
    init(duration: Double, presentOrDismiss: PresentOrDismiss) {
        self.duration = duration
        self.presentOrDismiss = presentOrDismiss
    }
    
    enum PresentOrDismiss {
        case present
        case dismiss
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return CFTimeInterval(exactly: duration) ?? 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        
        let rightTop = CGAffineTransform(translationX: containerView.frame.width, y: -containerView.frame.height)
        
        switch presentOrDismiss {
        case .present:
            toView?.transform = rightTop
            UIView.animate(withDuration: duration,
                           delay: 0.0,
                           usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 0.5,
                           options: [],
                           animations: {
                            toView?.transform = .identity
                },
                           completion: { (_) in
                        transitionContext.completeTransition(true)
            }
            )
            if let toView = toView {
            containerView.addSubview(toView)
            }
        case .dismiss:
            UIView.animate(withDuration: duration,
                           delay: 0.0,
                           options: [],
                           animations: {
                            fromView?.transform = rightTop
                },
                           completion: { (_) in
                        toView?.removeFromSuperview()
                        transitionContext.completeTransition(true)
            }
            )
            if let fromView = fromView {
            containerView.addSubview(fromView)
            }
        }
    }
}
