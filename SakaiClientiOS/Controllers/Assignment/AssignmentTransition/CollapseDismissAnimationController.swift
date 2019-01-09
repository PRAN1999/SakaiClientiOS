//
//  CollapseDismissAnimationController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/24/18.
//

import Foundation
import UIKit

/// Shrink Assignment page down to size of Assignment card
class CollapseDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    private let resizingDuration: TimeInterval

    init(resizingDuration: TimeInterval) {
        self.resizingDuration = resizingDuration
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return resizingDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView

        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? Animatable,
            let fromView = fromVC.containerView
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

        guard
            let toChildFrame = toVC.childViewFrame,
            let toContainer = toVC.containerView
            else {
                transitionContext.completeTransition(false)
                return
        }

        let toChild = toVC.childView

        container.addSubview(toView)
        container.addSubview(fromView)

        let originFrame = fromView.frame
        let destinationFrame = CGRect(
            origin: toContainer.convert(toChildFrame.origin, to: container),
            size: toChildFrame.size
        )

        toChild?.isHidden = true

        let yDiff = destinationFrame.origin.y - originFrame.origin.y
        let xDiff = destinationFrame.origin.x - originFrame.origin.x

        let springParams = UISpringTimingParameters(dampingRatio: 0.75)
        let sizeAnimator = UIViewPropertyAnimator(duration: resizingDuration,
                                                  timingParameters: springParams)
        sizeAnimator.addAnimations {
            fromView.frame.size = destinationFrame.size
            fromView.layoutIfNeeded()

            fromView.transform = CGAffineTransform(translationX: 0, y: yDiff)
            fromView.transform = fromView.transform
                .concatenating(CGAffineTransform(translationX: xDiff, y: 0))
        }

        // Call the animation delegate
        fromVC.dismissingView(
            sizeAnimator: sizeAnimator,
            fromFrame: originFrame,
            toFrame: destinationFrame
        )

        // Animation completion.
        let completionHandler: (UIViewAnimatingPosition) -> Void = { _ in
            fromView.removeFromSuperview()
            toChild?.isHidden = false

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        sizeAnimator.addCompletion(completionHandler)

        sizeAnimator.startAnimation()
    }

}
