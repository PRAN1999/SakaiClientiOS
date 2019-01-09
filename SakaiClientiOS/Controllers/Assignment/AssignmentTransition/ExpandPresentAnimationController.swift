//
//  ExpandPresentAnimationController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/23/18.
//

import Foundation
import UIKit

/// Animate from Assignment Card to full-screen Assignment page
class ExpandPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    private let resizingDuration: TimeInterval

    init(resizingDuration: TimeInterval) {
        self.resizingDuration = resizingDuration
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?)
        -> TimeInterval {
        return resizingDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView

        // Views we are animating FROM
        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? Animatable,
            let fromContainer = fromVC.containerView,
            let fromChild = fromVC.childView
            else {
                transitionContext.completeTransition(false)
                return
        }

        // Views we are animating TO
        guard
            let toVC = transitionContext.viewController(forKey: .to) as? Animatable,
            let toView = transitionContext.view(forKey: .to)
            else {
                transitionContext.completeTransition(false)
                return
        }

        container.addSubview(toView)

        let originFrame = CGRect(
            origin: fromContainer.convert(fromChild.frame.origin, to: container),
            size: fromChild.frame.size
        )
        let destinationFrame = toView.frame

        let duration = resizingDuration

        toView.frame = originFrame
        toView.layer.cornerRadius = AssignmentCell.cornerRadius
        toView.layoutIfNeeded()

        let yDiff = destinationFrame.origin.y - originFrame.origin.y
        let xDiff = destinationFrame.origin.x - originFrame.origin.x

        let springParams = UISpringTimingParameters(dampingRatio: 0.75)
        let sizeAnimator = UIViewPropertyAnimator(duration: duration,
                                                  timingParameters: springParams)
        sizeAnimator.addAnimations {
            // Animate the size of the Detail View
            toView.frame.size = destinationFrame.size
            toView.layoutIfNeeded()

            toView.transform = CGAffineTransform(translationX: 0, y: yDiff)
            toView.transform = toView.transform
                .concatenating(CGAffineTransform(translationX: xDiff, y: 0))
        }

        let completionHandler: (UIViewAnimatingPosition) -> Void = { _ in
            toView.transform = .identity
            toView.frame = destinationFrame
            toView.layer.cornerRadius = 0
            toView.layoutIfNeeded()

            fromChild.isHidden = false

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        sizeAnimator.addCompletion(completionHandler)

        toVC.presentingView(
            sizeAnimator: sizeAnimator,
            fromFrame: originFrame,
            toFrame: destinationFrame
        )

        sizeAnimator.startAnimation()
    }
}
