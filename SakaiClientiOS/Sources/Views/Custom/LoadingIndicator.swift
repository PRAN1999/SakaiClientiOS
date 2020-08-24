//
//  LoadingIndicator.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/12/18.
//

import UIKit

/// A default ActivityIndicator to be used across the app
class LoadingIndicator: UIActivityIndicatorView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style = UIActivityIndicatorView.Style.whiteLarge
        color = Palette.main.activityIndicatorColor
        backgroundColor = UIColor.clear
        hidesWhenStopped = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    /// Instantiates an ActivityIndicatorView and then adds it to the center
    /// of a superview
    ///
    /// - Parameters:
    ///   - frame: the frame for the Indicator
    ///   - view: the view to which the loading indicator should be added
    convenience init(frame: CGRect, view: UIView) {
        self.init(frame: frame)
        view.addSubview(self)
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        view.bringSubviewToFront(self)
    }

    /// Instantiates ActivityIndicatorView in a 100 x 100 square and adds to
    /// center of superview
    ///
    /// - Parameter view: the view to which the indicator should be added
    convenience init(view: UIView) {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.init(frame: frame, view: view)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
