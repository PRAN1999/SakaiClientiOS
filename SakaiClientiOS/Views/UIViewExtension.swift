//
//  UIViewUtility.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 11/8/18.
//

import Foundation
import UIKit

extension UIView {

    static func constrainChildToEdges(child: UIView, parent: UIView) {
        parent.addSubview(child)
        
        child.translatesAutoresizingMaskIntoConstraints = false
        child.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        child.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        child.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        child.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
    }

    static func defaultAutoLayoutView<T: UIView>() -> T {
        let view = T(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
