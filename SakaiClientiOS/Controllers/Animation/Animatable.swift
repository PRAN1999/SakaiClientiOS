//
//  Animatable.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/24/18.
//

import Foundation
import UIKit

/// Aids ViewController animation by specifying origin and target frames
protocol Animatable {

    /// Parent of view animating from
    var containerView: UIView? { get }
    /// Target view (either from or to)
    var childView: UIView? { get }

    // If the childView or containerView were to change after the transition,
    // having access to the frame that should be transitioned to helps keep
    // the animation in context. I.E. as the PageController pages, the cell
    // it should animate back to in the previous controller's collectionView
    // will change

    var containerViewFrame: CGRect? { get }
    var childViewFrame: CGRect? { get }

    /// Allows fromViewController to manipulate view before transition
    /// occurs in order to smooth transition appearance (i.e. changing
    /// margins) when presenting a new controller.
    ///
    /// - Parameters:
    ///   - sizeAnimator: the sizeAnimator used to animate the transition
    ///   - fromFrame: frame of the view animating from
    ///   - toFrame: frame of view animating to
    func presentingView(
        sizeAnimator: UIViewPropertyAnimator,
        fromFrame: CGRect,
        toFrame: CGRect
    )

    /// Allows fromViewController to manipulate view before transition
    /// occurs in order to smooth transition appearance (i.e. changing
    /// margins) when being dismissed
    ///
    /// - Parameters:
    ///   - sizeAnimator: the sizeAnimator used to animate the transition
    ///   - fromFrame: frame of the view animating from
    ///   - toFrame: frame of view animating to
    func dismissingView(
        sizeAnimator: UIViewPropertyAnimator,
        fromFrame: CGRect,
        toFrame: CGRect
    )
}

/// Default implementations
extension Animatable {

    var containerViewFrame: CGRect? {
        return containerView?.frame
    }

    var childViewFrame: CGRect? {
        return childView?.frame
    }

    func presentingView(
        sizeAnimator: UIViewPropertyAnimator,
        fromFrame: CGRect,
        toFrame: CGRect
        ) {}

    func dismissingView(
        sizeAnimator: UIViewPropertyAnimator,
        fromFrame: CGRect,
        toFrame: CGRect
        ) {}
}
