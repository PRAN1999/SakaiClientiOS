//
//  Animatable.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/24/18.
//

import Foundation
import UIKit

protocol Animatable {
    var containerView: UIView? { get }
    var childView: UIView? { get }

    func presentingView(
        sizeAnimator: UIViewPropertyAnimator,
        fromFrame: CGRect,
        toFrame: CGRect
    )

    func dismissingView(
        sizeAnimator: UIViewPropertyAnimator,
        fromFrame: CGRect,
        toFrame: CGRect
    )
}

/// Default implementations
extension Animatable {
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
