//
//  SystemPopAnimator.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/11/19.
//

import UIKit

class SystemPopAnimator: NSObject, UIViewControllerAnimatedTransitioning, Interactable {

    let duration: TimeInterval
    let interactionController: UIPercentDrivenInteractiveTransition?

    init(duration: TimeInterval,
         interactionController: UIPercentDrivenInteractiveTransition? = nil) {
        self.duration = duration
        self.interactionController = interactionController
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromView = fromViewController.view,
            let toView = toViewController.view
            else {
                return
        }
        let containerView = transitionContext.containerView
        containerView.insertSubview(toView, belowSubview: fromView)

        let animations = {
            let offset = fromViewController.view.frame.minY
            let originFrame = fromViewController.view.frame
            fromViewController.view.frame = containerView.bounds.offsetBy(dx: containerView.frame.size.width, dy: offset)
            toViewController.view.frame = originFrame
        }

        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0,
                       options: [.curveEaseOut], animations: animations) { _ in

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

