//
//  UIViewUtility.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 11/8/18.
//

import Foundation
import UIKit

protocol Layoutable {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
}

extension UILayoutGuide: Layoutable {}
extension UIView: Layoutable {}

extension NSLayoutConstraint {
    func withPriority(priority: Float) -> NSLayoutConstraint {
        let priority = UILayoutPriority(rawValue: priority)
        self.priority = priority
        return self
    }
}

extension UIView {

    static func defaultAutoLayoutView<T: UIView>() -> T {
        let view = T(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    enum ViewSide {
        case left, right, top, bottom
    }

    func constrainToEdges(of parent: Layoutable) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parent.topAnchor),
            bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor)
        ])
    }

    func constrainToMargins(of parent: UIView) {
        let margins = parent.layoutMarginsGuide
        constrainToEdges(of: margins)
    }

    func constrainToEdge(of parent: Layoutable, onSide side: ViewSide) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint
        switch side {
        case .left:
            constraint = leadingAnchor.constraint(equalTo: parent.leadingAnchor)
        case .right:
            constraint = trailingAnchor.constraint(equalTo: parent.trailingAnchor)
        case .top:
            constraint = topAnchor.constraint(equalTo: parent.topAnchor)
        case .bottom:
            constraint = bottomAnchor.constraint(equalTo: parent.bottomAnchor)
        }
        constraint.isActive = true
    }

    func constrainToMargin(of parent: UIView, onSide side: ViewSide) {
        let margins = parent.layoutMarginsGuide
        constrainToEdge(of: margins, onSide: side)
    }

    func constrainToEdges(of parent: Layoutable, onSides sides: [ViewSide]) {
        for side in sides {
            constrainToEdge(of: parent, onSide: side)
        }
    }

    func constrainToMargins(of parent: UIView, onSides sides: [ViewSide]) {
        let margins = parent.layoutMarginsGuide
        constrainToEdges(of: margins, onSides: sides)
    }

    func addBorder(toSide side: ViewSide, withColor color: UIColor, andThickness thickness: CGFloat) {
        let border = UIView.defaultAutoLayoutView()
        border.backgroundColor = color
        addSubview(border)

        switch side {
        case .left:
            border.constrainToEdges(of: self, onSides: [.top, .bottom, .left])
            border.widthAnchor.constraint(equalToConstant: thickness).isActive = true
        case .right:
            border.constrainToEdges(of: self, onSides: [.top, .bottom, .right])
            border.widthAnchor.constraint(equalToConstant: thickness).isActive = true
        case .top:
            border.constrainToEdges(of: self, onSides: [.top, .left, .right])
            border.heightAnchor.constraint(equalToConstant: thickness).isActive = true
        case .bottom:
            border.constrainToEdges(of: self, onSides: [.bottom, .left, .right])
            border.heightAnchor.constraint(equalToConstant: thickness).isActive = true
        }
        bringSubviewToFront(border)
    }

    func addBorder(
        toSide side: ViewSide, withColor color: UIColor, andTransparency alpha: CGFloat, andThickness thickness: CGFloat
    ) {
        addBorder(toSide: side, withColor: color.color(withTransparency: alpha), andThickness: thickness)
    }
}
