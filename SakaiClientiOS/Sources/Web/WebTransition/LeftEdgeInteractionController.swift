//
//  LeftEdgeInteractionController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/11/19.
//

import Foundation
import UIKit
import WebKit

class LeftEdgeInteractionController: UIPercentDrivenInteractiveTransition {

    var inProgress = false
    private(set) var edge: UIScreenEdgePanGestureRecognizer?

    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!

    init(view: UIView, in controller: UIViewController) {
        super.init()
        viewController = controller
        self.setupGestureRecognizer(in: view)
    }

    private func setupGestureRecognizer(in view: UIView) {
        let edge = UIScreenEdgePanGestureRecognizer(target: self,
                                                    action: #selector(self.handleEdgePan(_:)))
        edge.edges = .left
        edge.delegate = self
        view.addGestureRecognizer(edge)
        self.edge = edge
    }

    @objc func handleEdgePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        let translate = gesture.translation(in: gesture.view)
        let percent = translate.x / gesture.view!.bounds.size.width

        switch gesture.state {
        case .began:
            self.inProgress = true
            if let navigationController = viewController.navigationController {
                navigationController.popViewController(animated: true)
                return
            }
            viewController.dismiss(animated: true, completion: nil)
        case .changed:
            self.update(percent)
        case .cancelled:
            self.inProgress = false
            self.cancel()
        case .ended:
            self.inProgress = false

            let velocity = gesture.velocity(in: gesture.view)

            if percent > 0.5 || velocity.x > 0 {
                self.finish()
            }
            else {
                self.cancel()
            }
        default:
            break
        }
    }
}

extension LeftEdgeInteractionController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

