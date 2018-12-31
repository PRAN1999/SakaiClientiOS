//
//  UIViewUtility.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 11/8/18.
//

import Foundation
import UIKit

extension UIView {

    enum ViewSide {
        case left, right, top, bottom
    }

    static func constrainChildToEdges(child: UIView, parent: UIView) {
        parent.addSubview(child)
        
        child.translatesAutoresizingMaskIntoConstraints = false
        child.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        child.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        child.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        child.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
    }

    static func constrainChildToEdgesAndBottomMargin(child: UIView, parent: UIView) -> NSLayoutConstraint {
        parent.addSubview(child)
        let margins = parent.layoutMarginsGuide

        child.translatesAutoresizingMaskIntoConstraints = false
        child.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        child.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        child.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true

        let bottomConstraint = child.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        bottomConstraint.isActive = true
        return bottomConstraint
    }

    static func defaultAutoLayoutView<T: UIView>() -> T {
        let view = T(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func addBorder(toSide side: ViewSide, withColor color: UIColor, andThickness thickness: CGFloat) {
        let border = UIView.defaultAutoLayoutView()
        border.backgroundColor = color
        addSubview(border)

        switch side {
        case .left:
            NSLayoutConstraint.activate([
                border.topAnchor.constraint(equalTo: topAnchor),
                border.bottomAnchor.constraint(equalTo: bottomAnchor),
                border.leadingAnchor.constraint(equalTo: leadingAnchor),
                border.widthAnchor.constraint(equalToConstant: thickness)
            ])
            break
        case .right:
            NSLayoutConstraint.activate([
                border.topAnchor.constraint(equalTo: topAnchor),
                border.bottomAnchor.constraint(equalTo: bottomAnchor),
                border.trailingAnchor.constraint(equalTo: trailingAnchor),
                border.widthAnchor.constraint(equalToConstant: thickness)
            ])
            break
        case .top:
            NSLayoutConstraint.activate([
                border.topAnchor.constraint(equalTo: topAnchor),
                border.leadingAnchor.constraint(equalTo: leadingAnchor),
                border.trailingAnchor.constraint(equalTo: trailingAnchor),
                border.heightAnchor.constraint(equalToConstant: thickness)
            ])
            break
        case .bottom:
            NSLayoutConstraint.activate([
                border.bottomAnchor.constraint(equalTo: bottomAnchor),
                border.leadingAnchor.constraint(equalTo: leadingAnchor),
                border.trailingAnchor.constraint(equalTo: trailingAnchor),
                border.heightAnchor.constraint(equalToConstant: thickness)
            ])
            break
        }
    }

    func addBorder(toSide side: ViewSide, withColor color: UIColor, andTransparency alpha: CGFloat, andThickness thickness: CGFloat) {
        addBorder(toSide: side, withColor: color.color(withTransparency: alpha), andThickness: thickness)
    }
}
